extends KinematicBody2D

export(int) var max_speed = 100
export(int) var acceleration = 300
export(float) var friction_weight = 0.05
export(float) var rotation_speed = 3.5

var LaserScene: PackedScene = preload("res://projectiles/Laser.tscn")

var motion = Vector2.ZERO
var can_fire = true
var input_vector: Vector2
var velocity: Vector2
var rotation_dir: int

onready var name_label = $NameLabel
onready var camera = $Camera2D
onready var muzzle = $Muzzle
onready var cooldown_timer = $CooldownTimer
onready var collision_polygon = $CollisionPolygon2D
onready var laser_audio = $LaserAudio
onready var death_audio = $DeathAudio


func _ready() -> void:
	name_label.set_as_toplevel(true)
	print(Network.players)
	set_player_name()


# only master player calls this
func _physics_process(delta: float) -> void:
	if is_network_master():
		camera.current = true
		name_label.rect_position = Vector2(position.x - 40, position.y - 60)
		apply_movement(delta)
		fire()
		rpc_unreliable_id(1, "req_update_player", global_transform)


# update puppet players
remote func res_update_player(transform: Transform2D) -> void:
	if not is_network_master():
		name_label.rect_position = Vector2(position.x - 40, position.y - 60)
		set_global_transform(transform)


func apply_movement(delta: float) -> void:
	input_vector.x = Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
	rotation_dir = 0
	if Input.is_action_pressed("turn_right"):
		rotation_dir += 1
	if Input.is_action_pressed("turn_left"):
		rotation_dir -= 1
	velocity += Vector2(input_vector.x * acceleration * delta, 0).rotated(rotation)
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	if input_vector.x == 0 and velocity != Vector2.ZERO:
		velocity = lerp(velocity, Vector2.ZERO, friction_weight)
		if velocity.length() < 0.1:
			velocity = Vector2.ZERO
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)


func set_player_name() -> void:
	name_label.text = Network.players[int(name)]["player_name"]


func fire() -> void:
	if Input.is_action_pressed("fire") and can_fire:
		rpc_id(1, "req_fire")
		laser_audio.play()
		can_fire = false
		cooldown_timer.start()


sync func res_spawn_laser() -> void:
	var laser = LaserScene.instance()
	get_tree().get_root().get_node("World").add_child(laser)
	laser.transform = muzzle.global_transform


func _on_CooldownTimer_timeout() -> void:
	can_fire = true


func take_damage() -> void:
	rpc_id(1, "req_destroy_player")


sync func res_destroy_player() -> void:
	set_physics_process(false)
	collision_polygon.disabled = true
	death_audio.play()
	hide()
	name_label.hide()



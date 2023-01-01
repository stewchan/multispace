extends KinematicBody2D

export(int) var max_speed = 100
export(int) var acceleration = 300
export(int) var friction = 200

var LaserScene: PackedScene = preload("res://projectiles/Laser.tscn")

var motion = Vector2.ZERO
var can_fire = true

onready var name_label = $NameLabel
onready var camera = $Camera2D
onready var muzzle = $Muzzle
onready var cooldown_timer = $CooldownTimer


func _ready() -> void:
	name_label.set_as_toplevel(true)
	print(Network.players)
	set_player_name()


# only master player calls this
func _physics_process(delta: float) -> void:
	if is_network_master():
		camera.current = true
		name_label.rect_position = Vector2(position.x - 40, position.y - 60)
		var input_vector = get_input_vector()
		apply_movement(input_vector, delta)
		fire()
		rpc_unreliable_id(1, "req_update_player", global_transform)


# update puppet players
remote func res_update_player(transform: Transform2D) -> void:
	if not is_network_master():
		name_label.rect_position = Vector2(position.x - 40, position.y - 60)
		set_global_transform(transform)


func get_input_vector() -> Vector2:
	var dx = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var dy = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return Vector2(dx, dy).normalized()


func apply_movement(input_vector: Vector2, delta: float) -> void:
	look_at(get_global_mouse_position())
	if input_vector != Vector2.ZERO:
		motion = motion.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		motion = motion.move_toward(Vector2.ZERO, friction * delta)
	motion = move_and_slide(motion)


func set_player_name() -> void:
	name_label.text = Network.players[int(name)]["player_name"]


func fire() -> void:
	if Input.is_action_pressed("fire") and can_fire:
		rpc_id(1, "req_fire")
		can_fire = false
		cooldown_timer.start()


sync func res_spawn_laser() -> void:
	var laser = LaserScene.instance()
	get_tree().get_root().get_node("World").add_child(laser)
	laser.transform = muzzle.global_transform


func _on_CooldownTimer_timeout() -> void:
	can_fire = true

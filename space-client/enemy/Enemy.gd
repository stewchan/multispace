extends KinematicBody2D


export(int) var max_speed = 80
export(int) var acceleration = 300

var motion = Vector2.ZERO
var players: Array
var target_player: KinematicBody2D

onready var players_container = get_tree().get_root().find_node("Players", true, false)
onready var world = get_tree().root.get_node("World")


func _ready():
	players = players_container.get_children()
	target_player = players[randi() % players.size()]
	rpc_id(1, "req_select_target")


remote func res_select_player_target(idx: int) -> void:
	target_player = players[idx]


func _physics_process(delta: float) -> void:
	var direction = (target_player.position - global_position).normalized()
	motion = motion.move_toward(direction * max_speed, acceleration * delta)
	motion = move_and_slide(motion)


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	print("enemy hurtbox entered by: " + str(area))
	rpc_id(1, "req_destroy_enemy")
	queue_free()


func _on_Hitbox_body_entered(body: Node) -> void:
	print("enemy hitbox entered by: " + str(body))
	if body.has_method("take_damage"):
		body.take_damage()
	

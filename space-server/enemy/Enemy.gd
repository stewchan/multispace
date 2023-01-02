extends Node

onready var players = get_tree().get_root().find_node("Players", true, false)


func _ready() -> void:
	randomize()


remote func req_select_target():
	var num_players = players.get_children().size()
	var idx = randi() % num_players
	rpc("res_select_player_target", idx)


remote func req_destroy_enemy():
	queue_free()

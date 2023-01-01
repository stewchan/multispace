extends Node

const PlayerScene: PackedScene = preload("res://player/Player.tscn")

onready var players = $Players


remote func req_spawn_player() -> void:
	var pid = get_tree().get_rpc_sender_id()
	var player = PlayerScene.instance()
	player.name = str(pid)
	players.add_child(player)
	rpc("res_spawn_player", pid)

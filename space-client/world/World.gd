extends Node2D

const PlayerScene: PackedScene = preload("res://player/Player.tscn")

onready var player_spawn = $PlayerSpawn
onready var players = $Players


func _ready() -> void:
	rpc_id(1, "req_spawn_player")


remote func res_spawn_player(pid: int) -> void:
	var player = PlayerScene.instance()
	player.name = str(pid)
	players.add_child(player)
	player.set_network_master(pid)
	player.position = player_spawn.position

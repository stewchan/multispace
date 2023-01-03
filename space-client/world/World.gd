extends Node2D

const PlayerScene: PackedScene = preload("res://player/Player.tscn")
const EnemyScene: PackedScene = preload("res://enemy/Enemy.tscn")

var spawnpoints: Array

onready var players = $Players
onready var enemies = $Enemies


func spawn_player(pid:int) -> void:
	rpc_id(1, "req_spawn_player", pid)


remote func res_spawn_player(pid: int, pos: Vector2) -> void:
	if players.get_node_or_null(str(pid)):
		return
	var player = PlayerScene.instance()
	player.name = str(pid)
	players.add_child(player)
	player.set_network_master(pid)
	player.position = pos


remote func res_spawn_enemy(enemy_json: String) -> void:
	var data = str2var(enemy_json)
	var enemy = EnemyScene.instance()
	enemy.name = data.name
	enemy.max_speed = data.max_speed
	enemies.add_child(enemy)
	enemy.global_position = data.global_position

extends Node2D

const PlayerScene: PackedScene = preload("res://player/Player.tscn")
const EnemyScene: PackedScene = preload("res://enemy/Enemy.tscn")

var spawnpoints: Array

onready var player_spawn = $PlayerSpawn
onready var players = $Players
onready var spawnpoints_container = $EnemySpawn
onready var enemies = $Enemies


func _ready() -> void:
	spawnpoints = spawnpoints_container.get_children()
	rpc_id(1, "req_spawn_player")


remote func res_spawn_player(pid: int) -> void:
	var player = PlayerScene.instance()
	player.name = str(pid)
	players.add_child(player)
	player.set_network_master(pid)
	player.position = player_spawn.position


remote func res_spawn_enemy(idx, enemy_name) -> void:
	var spawnpoint = spawnpoints[idx]
	var enemy = EnemyScene.instance()
	enemy.name = enemy_name
	enemies.add_child(enemy)
	enemy.position = spawnpoint.position


func _on_EnemySpawnTimer_timeout() -> void:
	rpc_id(1, "req_spawn_enemy", spawnpoints.size())

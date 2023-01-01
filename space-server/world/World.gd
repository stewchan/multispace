extends Node

const PlayerScene: PackedScene = preload("res://player/Player.tscn")
const EnemyScene: PackedScene = preload("res://enemy/Enemy.tscn")

var enemy_count = 0
var max_enemies = 5

onready var players = $Players
onready var enemies = $Enemies


remote func req_spawn_player() -> void:
	var pid = get_tree().get_rpc_sender_id()
	var player = PlayerScene.instance()
	player.name = str(pid)
	players.add_child(player)
	rpc("res_spawn_player", pid)


remote func req_spawn_enemy() -> void:
	if enemy_count < max_enemies:
		var enemy = EnemyScene.instance()
		var idx = randi() % 4
		enemy.name = str(enemy_count)
		enemy_count += 1
		enemies.add_child(enemy)
		rpc("res_spawn_enemy", idx, enemy.name)

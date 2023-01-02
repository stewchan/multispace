extends Node

const PlayerScene: PackedScene = preload("res://player/Player.tscn")
const EnemyScene: PackedScene = preload("res://enemy/Enemy.tscn")

var enemy_count = 0
var world_size = Vector2(1000, 600)

onready var players = $Players
onready var enemies = $Enemies
onready var enemy_spawn_timer = $EnemySpawnTimer


remote func req_spawn_player() -> void:
	var pid = get_tree().get_rpc_sender_id()
	var player = PlayerScene.instance()
	player.name = str(pid)
	players.add_child(player)
	rpc("res_spawn_player", pid)


func _on_EnemySpawnTimer_timeout() -> void:
	var enemy = EnemyScene.instance()
	enemy_count += 1
	enemy.name = str(enemy_count)
	var global_position = Vector2(randi() % int(world_size.x), randi() % int(world_size.y))
	var data = {
		"name": enemy.name,
		"global_position": global_position,
		"max_speed": enemy.max_speed
	}
	enemies.add_child(enemy)
	rpc("res_spawn_enemy", var2str(data))
	

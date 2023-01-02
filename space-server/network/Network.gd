# warning-ignore-all:return_value_discarded
extends Node

var peer = NetworkedMultiplayerENet.new()
var port = 3234
var max_players = 32

var players = {}
var ready_players = 0
var min_players = 2

const WorldScene: PackedScene = preload("res://world/World.tscn")


func _ready() -> void:
	start_server()


func start_server() -> void:
	peer.create_server(port, max_players)
	get_tree().set_network_peer(peer)
	get_tree().connect("network_peer_connected", self, "on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "on_player_disconnected")

	print("Server started on port " + str(port) + " with " + str(max_players) + " players")


func on_player_connected(id: int) -> void:
	print("Player connected: " + str(id))


func on_player_disconnected(id: int) -> void:
	print("Player disconnected: " + str(id))
	var player = get_node("/root/World/Players/" + str(id))
	if player:
		player.req_destroy_player()
		player.queue_free()


remote func req_player_info(player_json: String) -> void:
	var pid = get_tree().get_rpc_sender_id()
	var player_data = str2var(player_json)
	players[pid] = player_data
	var players_json = var2str(players)
	rpc("res_update_players", players_json)


remote func req_load_world():
	ready_players += 1
	if players.size() >= min_players and ready_players >= players.size():
		rpc("res_start_game")
		var world = WorldScene.instance()
		world.name = "World"
		get_tree().get_root().add_child(world)

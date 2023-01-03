# warning-ignore-all:return_value_discarded
extends Node

var peer = NetworkedMultiplayerENet.new()
var port = 3234
var max_players = 32

var world_instance = null
var world_data = {
	"size": Vector2(1000, 600)
}
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


func on_player_disconnected(pid: int) -> void:
	print("Player disconnected: " + str(pid))
	players.erase(pid)
	var player = get_node_or_null("/root/World/Players/" + str(pid))
	if player:
		player.queue_free()
		rpc("res_remove_player", pid)		


remote func req_register_player(player_json: String) -> void:
	var pid = get_tree().get_rpc_sender_id()
	var player_data = str2var(player_json)
	players[pid] = player_data
	var players_json = var2str(players)
	rpc("res_update_players", players_json)


remote func req_launch_game():
	ready_players += 1
	# First player to join creates the world
	if not world_instance:
		world_instance = WorldScene.instance()
		world_instance.name = "World"
		get_tree().get_root().add_child(world_instance)
	var pid = get_tree().get_rpc_sender_id()
	rpc_id(pid, "res_init_world", var2str(world_data), var2str(players))

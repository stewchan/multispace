# warning-ignore-all:return_value_discarded
extends Node

var peer = NetworkedMultiplayerENet.new()
var port = 3234
var max_players = 32

var players = {}


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


remote func req_player_info(player_json: String) -> void:
	var pid = get_tree().get_rpc_sender_id()
	var player_data = str2var(player_json)
	print(player_data)
	players[pid] = player_data
	rpc("res_update_players", player_json)
	rpc("res_update_waiting_room")

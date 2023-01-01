# warning-ignore-all:return_value_discarded
extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 3234

var peer = NetworkedMultiplayerENet.new()
var selected_IP = DEFAULT_IP
var selected_port = DEFAULT_PORT

var local_pid = 0
sync var players = {}
sync var player_data = {}

var WorldScene: PackedScene = preload("res://world/World.tscn")


func _ready() -> void:
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")


func connect_to_server() -> void:
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	peer.create_client(selected_IP, selected_port)
	get_tree().set_network_peer(peer)


func _on_connected_to_server() -> void:
	local_pid = get_tree().get_network_unique_id()
	print("Connected to server with peer id: " + str(local_pid))
	register_player()


func _on_server_disconnected() -> void:
	print("Server disconnected")


func _on_network_peer_connected(id) -> void:
	print("Player connected: ", id)


func _on_network_peer_disconnected(id) -> void:
	print("Player disconnected: ", id)


func register_player() -> void:
	player_data = Save.save_data
	players[local_pid] = player_data
	rpc_id(1, "req_player_info", var2str(player_data))


remote func res_update_players(players_json: String) -> void:
	var sender_id = get_tree().get_rpc_sender_id()
	if sender_id == 1:
		players = str2var(players_json)
	update_waiting_room()


func update_waiting_room() -> void:
	get_tree().call_group("WaitingRoom", "refresh_players", players)


func load_game() -> void:
	rpc_id(1, "req_load_world")


remote func res_start_game() -> void:
	var world = WorldScene.instance()
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("Lobby").queue_free()

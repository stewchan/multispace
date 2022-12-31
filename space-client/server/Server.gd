extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 3234

var network = NetworkedMultiplayerENet.new()
var selected_IP = DEFAULT_IP
var selected_port = DEFAULT_PORT

var local_player_id = 0
sync var players = {}
sync var player_data = {}


func _ready() -> void:
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")


func connect_to_server() -> void:
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	network.create_client(selected_IP, selected_port)
	get_tree().set_network_peer(network)


func _player_connected(id) -> void:
	print("Player connected: ", id)


func _player_disconnected(id) -> void:
	print("Player disconnected: ", id)


func _on_connected_to_server() -> void:
	print("Connected to server")


func _on_server_disconnected() -> void:
	print("Server disconnected")

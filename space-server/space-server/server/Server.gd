extends Node


var network = NetworkedMultiplayerENet.new()
var port = 3234
var max_players = 32


func _ready() -> void:
	start_server()


func start_server() -> void:
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	get_tree().connect("network_peer_connected", self, "on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "on_player_disconnected")

	print("Server started on port " + str(port) + " with " + str(max_players) + " players")


func on_player_connected(id: int) -> void:
	print("Player connected: " + str(id))


func on_player_disconnected(id: int) -> void:
	print("Player disconnected: " + str(id))

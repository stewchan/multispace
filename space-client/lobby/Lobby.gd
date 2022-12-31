extends Node2D


func _on_JoinButton_pressed() -> void:
	Server.connect_to_server()

extends Node2D


remote func req_update_player(transform: Transform2D) -> void:
	rpc_unreliable("res_update_player", transform)


remote func req_fire() -> void:
	rpc("res_spawn_laser")


remote func req_destroy_player() -> void:
	rpc("res_destroy_player")

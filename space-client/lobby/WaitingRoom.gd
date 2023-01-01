extends Popup


onready var player_list = $C/V/ItemList

func _ready() -> void:
	player_list.clear()


func refresh_players(players: Dictionary):
	player_list.clear()
	for pid in players:
		var name = players[pid].player_name
		player_list.add_item(name, null, false)

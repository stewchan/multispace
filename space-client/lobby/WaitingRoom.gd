extends Popup


onready var player_list = $C/V/ItemList

func _ready() -> void:
	player_list.clear()


func refresh_players(players: Dictionary):
	print(players)
	player_list.clear()
	for pid in players:
		var player = players[pid].player_name
		player_list.add_item(player, null, false)

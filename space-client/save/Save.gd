extends Node

# TODO: put saves on a server
const SAVEGAME_FILE = "user://savegame.json"

var save_data : Dictionary = {}


func _ready() -> void:
	save_data = get_data()


func get_data() -> Dictionary:
	var file = File.new()
	var data = {}
	if not file.file_exists(SAVEGAME_FILE):
		data = {"name": "Player" + str(randi() % 100)}
		save_game(data)
	else:
		file.open(SAVEGAME_FILE, File.READ)
		data = str2var(file.get_as_text())
		file.close()
	return data


func save_game(data: Dictionary = save_data) -> void:
	var save_game = File.new()
	save_game.open(SAVEGAME_FILE, File.WRITE)
	save_game.store_string(var2str(data))



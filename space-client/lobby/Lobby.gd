extends Node


onready var player_name = $C/V/G/NameTextbox
onready var selected_IP = $C/V/G/IPTextbox
onready var selected_port = $C/V/G/PortTextbox
onready var waiting_room = $WaitingRoom
onready var ready_button = $WaitingRoom/C/V/ReadyButton


func _ready() -> void:
	player_name.text = Save.save_data["player_name"]
	selected_IP.text = Network.DEFAULT_IP
	selected_port.text = str(Network.DEFAULT_PORT)
#	yield(get_tree(), "idle_frame")
#	_on_JoinButton_pressed()
#	_on_ReadyButton_pressed()
	

func _on_JoinButton_pressed() -> void:
	Network.selected_IP = selected_IP.text
	Network.selected_port = int(selected_port.text)
	Network.connect_to_server()
	show_waiting_room()


func _on_NameTextbox_text_changed(_new_text: String) -> void:
	Save.save_data["player_name"] = player_name.text
	Save.save_game()


func show_waiting_room():
	waiting_room.popup_centered()


func _on_ReadyButton_pressed() -> void:
	Network.load_game()
	ready_button.disabled = true
	

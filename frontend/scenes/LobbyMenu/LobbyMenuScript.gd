extends Node

# change this with the address and port of your server
export var websocket_url = "ws://localhost:3001"


func _ready():
	WsManager.connect("data_received", self, '_on_data')
	WsManager.connect_to_ws(websocket_url)


func _on_data(data):
	print(data)
	match data.message:
		"Your id":
			_handle_my_id_received(data)
		"Joined room":
			_handle_room_joined(data)
		"Guest joined":
			_handle_player_joined(data)
		"Failed to join game":
			_handle_failed_to_join_game(data)


func _on_Create_pressed():
	WsManager.send_data({"message": "create"})
	_hide_main_menu()
	_start_loading()


func _handle_my_id_received(data):
	LobbyManager.selfId = data.get("id")
	LobbyManager.username = data.get("name")
	$Control/MainMenu/Username.text = "Connected as: " + data.get("name")


func _handle_room_joined(data):
	LobbyManager.lobby = {
		"id": data.get("gameId"), "guests": data.get("guests"), "spectators": data.get("spectators")
	}
	_stop_loading()
	_show_lobby()
	if data.get("role") != "spectator":
		_handle_player_joined(
			{"guest": 
				{"id":LobbyManager.selfId, "name": LobbyManager.username, "isHost":false}
			}
		)
	else:
		_handle_spectator_joined(
			{"guest": 
				{"id":LobbyManager.selfId, "name": LobbyManager.username, "isHost":false}
			}
		)


func _handle_failed_to_join_game(data):
	_stop_loading()
	_show_error(data.message + ": " + data.reason)


func _handle_player_joined(data):
	var guestND = data.get("guest")
	LobbyManager.lobby.guests.push_back(
		{"id": guestND.get("id"), "name": guestND.get("name"), "isHost": guestND.get("isHost")}
	)

func _handle_spectator_joined(data):
	var guestND = data.get("guest")
	LobbyManager.lobby.spectators.push_back(
		{"id": guestND.get("id"), "name": guestND.get("name"), "isHost": guestND.get("isHost")}
	)


func _show_main_menu():
	$Control/H1.show()
	$Control/FooterCredits.show()
	$Control/MainMenu.show()


func _hide_main_menu():
	$Control/H1.hide()
	$Control/FooterCredits.hide()
	$Control/MainMenu.hide()


func _show_lobby():
	$Control/InsideLobbyMenu.show()
	$Control/InsideLobbyMenu.update_code()


func _hide_lobby():
	$Control/InsideLobbyMenu.hide()


func _start_loading():
	$Control/Loading.show()


func _stop_loading():
	$Control/Loading.hide()


func _show_error(message):
	$Control/Error.show()
	$Control/Error/ErrorMessage.text = message


func _hide_error():
	$Control/Error.hide()


# Use this if you want to disconnect every time this scene is closed
# func _exit_tree():
# _client.disconnect_from_host(1000, "manual scene quit")


func _on_ButtonSetName_pressed():
	WsManager.send_data(
		{"message": "my name is", "name": $Control/MainMenu/ChooseName/LineEdit.text}
	)


func _on_ButtonJoin_pressed():
	WsManager.send_data(
		{"message": "join as guest", "gameId": $Control/MainMenu/Join/LineEdit.text}
	)
	_hide_main_menu()
	_start_loading()


func _on_ButtonBackError_pressed():
	_hide_error()
	_show_main_menu()

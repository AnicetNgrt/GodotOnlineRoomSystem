extends Node

# change this with the address and port of your server
export var websocket_url = "ws://localhost:3001"


func _ready():
	UserManager.connect("username_changed", self, "on_username_changed")
	LobbyManager.connect("room_joined", self, "on_room_joined")
	LobbyManager.connect("user_joined", self, "on_user_joined")
	LobbyManager.connect("failed_to_join_room", self, "on_failed_to_join_room")
	WsManager.connect_to_ws(websocket_url)


func _on_Create_pressed():
	LobbyManager.create_room()
	_hide_main_menu()
	_start_loading()


func on_username_changed(username):
	$Control/MainMenu/Username.text = "Connected as: " + username


func on_room_joined(room):
	_stop_loading()
	_show_lobby()


func on_failed_to_join_room(message, reason):
	_stop_loading()
	_show_error(message + ": " + reason)


func on_user_joined(userND):
	var listUi = $Control/InsideLobbyMenu/Lists/ConnectionLists/PlayerList
	listUi.add_connection(userND)

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

extends Node

# change this with the address and port of your server
export var websocket_url = "ws://localhost:3001"

onready var connections_list = $Control/InsideLobbyMenu/Lists/ConnectionLists/PlayerList


func _ready():
	UserManager.connect("username_changed", self, "on_username_changed")
	LobbyManager.connect("room_joined", self, "on_room_joined")
	LobbyManager.connect("user_joined", self, "on_user_joined")
	LobbyManager.connect("user_left", self, "on_user_left")
	LobbyManager.connect("left_room", self, "on_left_room")
	LobbyManager.connect("failed_to_join_room", self, "on_failed_to_join_room")
	LobbyManager.connect("room_deleted", self, "on_room_deleted")
	LobbyManager.connect("host_updated", self, "on_host_updated")
	LobbyManager.connect("game_started", self, "on_game_started")
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
	connections_list.add_connection(userND)


func on_user_left(userND):
	connections_list.remove_connection(userND)


func on_left_room():
	connections_list.reset()
	_hide_lobby()
	_show_main_menu()


func on_room_deleted():
	connections_list.reset()
	_hide_lobby()
	_show_error("The room you were in got deleted")


func on_game_started():
	$Control/InsideLobbyMenu/InviteCode/LineEdit.text = "Started!"


func on_host_updated(userId):
	if userId == UserManager.selfId:
		$Control/InsideLobbyMenu/StartButton.show()
	else:
		$Control/InsideLobbyMenu/StartButton.hide()


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
	UserManager.change_name($Control/MainMenu/ChooseName/LineEdit.text)


func _on_ButtonJoin_pressed():
	LobbyManager.join_room($Control/MainMenu/Join/LineEdit.text)
	_hide_main_menu()
	_start_loading()


func _on_ButtonBackError_pressed():
	_hide_error()
	_show_main_menu()


func _on_LeaveButton_pressed():
	LobbyManager.leave_room()


func _on_StartButton_pressed():
	LobbyManager.start_game()

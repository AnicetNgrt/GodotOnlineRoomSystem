extends Node

signal room_joined(room)
signal user_joined(userND)
signal user_left(userND)
signal left_room
signal failed_to_join_room(message, reason)
signal room_deleted
signal host_updated(userId)
signal game_started

var room = null


func create_room():
	WsManager.send_data({"message": "create room"})


func join_room(id):
	WsManager.send_data({"message": "join room", "gameId": id})


func leave_room():
	WsManager.send_data({"message": "leave room", "gameId": room.get("id")})


func get_room_id():
	return room.get("id")


func refresh_host():
	WsManager.send_data(
		{"message":"send host", "gameId": room.get("id")}
	)


func start_game():
	WsManager.send_data({"message":"start game", "gameId": room.get("id")})


func _ready():
	WsManager.connect("data_received", self, '_on_data')


func _on_data(data):
	print(data)
	match data.message:
		"Joined room":
			_handle_room_joined(data)
		"User joined":
			_handle_user_joined(data)
		"User left":
			_handle_user_left(data)
		"Update host":
			_handle_host_updated(data)
		"Failed to join room":
			_handle_failed_to_join_room(data)
		"Room deleted":
			_handle_room_deleted(data)
		"Game started":
			_handle_game_started(data)


func _handle_room_joined(data):
	room = {
		"id": data.get("roomId"), 
		"usersND": [],
		"isStarted": false
	}
	for userND in data.get("usersND"):
		_handle_user_joined({"userND": userND})
	emit_signal("room_joined", room)
	refresh_host()


func _handle_user_joined(data):
	room.get("usersND").push_back(data.get("userND"))
	emit_signal("user_joined", data.get("userND"))
	refresh_host()


func _handle_user_left(data):
	var to_delete = get_userND_by_id(data.get("userId"))
	if to_delete != null:
		room.get("usersND").erase(to_delete)
		if to_delete.get("id") == UserManager.selfId:
			emit_signal("left_room")
			room = null
		else:
			emit_signal("user_left", to_delete)
			refresh_host()


func _handle_host_updated(data):
	room["host"] = data.get("userId")
	emit_signal("host_updated", data.get("userId"))


func _handle_failed_to_join_room(data):
	emit_signal("failed_to_join_room", data.get("message"), data.get("reason"))


func _handle_room_deleted(data):
	emit_signal("room_deleted")
	room = null


func _handle_game_started(data):
	room["isStarted"] = true
	emit_signal("game_started")


func get_userND_by_id(id):
	for userND in room.get("usersND"):
		if userND.get("id") == id:
			return userND
	return null

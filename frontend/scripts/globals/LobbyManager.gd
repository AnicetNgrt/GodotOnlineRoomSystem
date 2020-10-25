extends Node

signal room_joined(room)
signal user_joined(userND)
signal user_left(userND)
signal left_room
signal failed_to_join_room(message, reason)
signal room_deleted

var room = null


func create_room():
	WsManager.send_data({"message": "create room"})


func join_room(id):
	WsManager.send_data({"message": "join room", "gameId": id})


func leave_room():
	WsManager.send_data({"message": "leave room", "gameId": room.get("id")})


func get_room_id():
	return room.get("id")


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
		"Failed to join room":
			_handle_failed_to_join_room(data)
		"Room deleted":
			_handle_room_deleted(data)


func _handle_room_joined(data):
	room = {"id": data.get("roomId"), "usersND": []}
	for userND in data.get("usersND"):
		_handle_user_joined({"userND": userND})
	emit_signal("room_joined", room)


func _handle_user_joined(data):
	room.get("usersND").push_back(data.get("userND"))
	emit_signal("user_joined", data.get("userND"))


func _handle_user_left(data):
	var to_delete = get_userND_by_id(data.get("userId"))
	if to_delete != null:
		room.get("usersND").erase(to_delete)
		if to_delete.get("id") == UserManager.selfId:
			emit_signal("left_room")
			room = null
		else:
			emit_signal("user_left", to_delete)


func _handle_failed_to_join_room(data):
	emit_signal("failed_to_join_room", data.get("message"), data.get("reason"))


func _handle_room_deleted(data):
	emit_signal("room_deleted")
	room = null


func get_userND_by_id(id):
	for userND in room.get("usersND"):
		if userND.get("id") == id:
			return userND
	return null

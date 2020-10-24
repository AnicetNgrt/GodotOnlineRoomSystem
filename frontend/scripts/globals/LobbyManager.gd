extends Node

signal room_joined(room)
signal user_joined(userND)
signal failed_to_join_room(message, reason)

var room = null

func create_room():
	WsManager.send_data({"message": "create room"})


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
		"Failed to join room":
			_handle_failed_to_join_room(data)

func _handle_room_joined(data):
	room = { "id":data.get("roomId"), "usersND":[] }
	for userND in data.get("usersND"):
		_handle_user_joined({"userND":userND})
	emit_signal("room_joined", room)

func _handle_user_joined(data):
	print(data)
	room.get("usersND").push_back(data.get("userND"))
	emit_signal("user_joined", data.get("userND"))


func _handle_failed_to_join_room(data):
	emit_signal("failed_to_join_room", data.get("message"), data.get("reason"))

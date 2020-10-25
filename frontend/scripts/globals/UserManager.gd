extends Node

var selfId = ""
var username = ""

signal username_changed(username)


func change_name(new_name):
	WsManager.send_data({"message": "my name is", "name": new_name})


func _ready():
	WsManager.connect("data_received", self, '_on_data')


func _on_data(data):
	match data.message:
		"Your id":
			_handle_my_id_received(data)


func _handle_my_id_received(data):
	selfId = data.get("id")
	username = data.get("name")
	emit_signal("username_changed", username)

tool
extends VBoxContainer

export(String) var title = "Group" setget _set_title

func _set_title(value):
	title = value
	$Title.text = value

func add_connection(connection, isHost, ping=""):
	var row = $Margin/Rows/Template.duplicate()
	$Margin/Rows.add_child(row)
	update_connection(connection, isHost, ping)

func update_connection(connection, isHost, ping=""):
	var row = get_node("Margin/Rows/"+connection["id"])
	if row != null:
		row.get_node('IsHost').visible = isHost
		row.get_node('Name').text = connection["name"]
		row.get_node('Ping').text = ping

func remove_connection(connection):
	var row = get_node("Margin/Rows/"+connection["id"])
	if row != null:
		remove_child(row)
		row.queue_free()

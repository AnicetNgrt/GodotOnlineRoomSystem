tool
extends VBoxContainer

export (String) var title = "Group" setget _set_title


func _set_title(value):
	title = value
	$Title.text = value


func add_connection(userND, ping = ""):
	var row = $Margin/Rows/Template.duplicate()
	$Margin/Rows.add_child(row)
	row.name = userND.get("id")
	row.visible = true
	update_connection(userND, ping)


func update_connection(userND, ping = ""):
	var row = get_node("Margin/Rows/" + userND.get("id"))
	if row != null:
		row.get_node('Name').text = userND.get("name")
		row.get_node('Ping').text = ping


func remove_connection(userND):
	var row = get_node("Margin/Rows/" + userND.get("id"))
	if row != null:
		row.get_parent().remove_child(row)
		row.queue_free()


func reset():
	var rows = get_node("Margin/Rows/")
	while rows.get_child_count() > 1:
		var child = rows.get_child(rows.get_child_count() - 1)
		rows.remove_child(child)

extends Control


func update_code():
	$InviteCode/LineEdit.text = LobbyManager.get_room_id()

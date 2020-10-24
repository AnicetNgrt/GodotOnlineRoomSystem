extends Control


func update_code():
	$InviteCode/LineEdit.text = LobbyManager.lobby.id

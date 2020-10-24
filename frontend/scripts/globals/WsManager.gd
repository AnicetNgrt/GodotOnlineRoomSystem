extends Node

var _client = WebSocketClient.new()

var is_connected = false

signal data_received(data)


func connect_to_ws(url):
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")

	var err = _client.connect_to_url(url)
	if err != OK:
		print("Unable to connect")
		set_process(false)


func send_data(data):
	_client.get_peer(1).put_packet(JSON.print(data).to_utf8())


func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	is_connected = false
	set_process(false)


func _connected(proto = ""):
	is_connected = true
	print("Connected with protocol: ", proto)


func _on_data():
	var data = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8()).result
	print(data)
	emit_signal("data_received", data)


func _process(delta):
	_client.poll()

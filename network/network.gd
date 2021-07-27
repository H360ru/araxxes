extends Node

func _init():
	print('network init')

func _ready():
	print('network ready')

func create_server(_cli: bool = true):
	var server = load(ProjectSettings.get_setting('global/server_path')).new()
	server.name = 'Server'
	yield(get_tree(),"idle_frame")
	add_child(server)
	server.create_server()

func create_client(_cli: bool = true):
	var _client = load(ProjectSettings.get_setting('global/client_path')).new()
	_client.name = 'Client'
	_client.login_name = '_login_name'
	yield(get_tree(),"idle_frame")
	add_child(_client)

func has_client():
	pass

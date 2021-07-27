extends Node

func _ready():
	var server = load('res://Server/Server.tscn').instance()
	server.login_name = '_login_name'
#	server.server_mode = 0
	yield(get_tree(),"idle_frame")
	Global.get_tree().get_root().add_child(server)
	server.create_client()
	
	


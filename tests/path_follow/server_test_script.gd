extends Node

func _ready():
	var server = load('res://Server/Server.tscn').instance()
	yield(get_tree(),"idle_frame")
	Global.get_tree().get_root().add_child(server)
	server.create_server()
	
#	Global.TWEEN.connect('tween_completed', self, 'tween_print')
#
#func tween_print(txt, txt2):
#	prints('Tween end', txt, txt2)

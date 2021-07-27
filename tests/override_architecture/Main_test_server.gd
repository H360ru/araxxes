extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	var server = load('res://Server/Server.tscn').instance()
#	yield(get_tree(),"idle_frame")
#	Global.get_tree().get_root().add_child(server)
#	server.create_server()
	Network.create_server()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

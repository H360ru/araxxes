extends Node2D

class_name Unit

signal move_finished

var map_position:Vector2

func move_along_path(path:Curve2D):
	emit_signal("move_finished")
	

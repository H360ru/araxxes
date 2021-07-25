extends Node2D

class_name Unit

export var move_speed := 200.0

var scene_state:UnitSceneState
var map_position:Vector2

func _init():
	scene_state = UnitSceneState.new()
	scene_state.connect("new_state", self, "on_new_state")
	
func on_new_state():
	pass

extends Node2D

class_name Unit

export var move_speed := 200.0

var scene_state:UnitSceneState
var map_position:Vector2

func _init():
	scene_state = UnitSceneState.new()

extends Node2D

class_name Unit

export var move_speed := 200.0
# Годо не дает доступ к энуму твина
export(int, "TRANS_LINEAR", "TRANS_SINE", "TRANS_QUINT", "TRANS_QUART", "TRANS_QUAD", "TRANS_EXPO", "TRANS_ELASTIC", "TRANS_CUBIC", "TRANS_CIRC", "TRANS_BOUNCE", "TRANS_BACK") var move_pattern

var scene_state:UnitSceneState
var map_position:Vector2

func _init():
	scene_state = UnitSceneState.new()
	scene_state.connect("new_state", self, "on_new_state")
	
func on_new_state():
	pass

extends Resource

class_name UnitSceneState

signal new_state

enum ActionStates{
	WAIT,
	IDLE,
	IN_MOVE,
	IN_ATTACK,
}

var action_state:int setget set_state

func set_state(state:int):
	action_state = state
	emit_signal("new_state")

var current_speed:float
var current_global_position:Vector2
var current_path_completeness:float
var current_map_position:Vector2
var current_look_angle:float
var current_path:Curve2D


var current_target_global_position:Vector2
var current_target_unit

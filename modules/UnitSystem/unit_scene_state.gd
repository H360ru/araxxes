extends Resource

class_name UnitSceneState

enum ActionStates{
	WAIT,
	IDLE,
	IN_MOVE,
	IN_ATTACK,
}

var action_state:int

var current_speed:float
var current_global_position:Vector2
var current_path_completeness:float
var current_map_position:Vector2
var current_look_angle:float
var current_path:Curve2D


var current_target_global_position:Vector2
var current_target_unit

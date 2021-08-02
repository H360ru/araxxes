extends Node

class_name Player

export(NodePath) var grid_node_path

onready var _grid_node = get_node(grid_node_path)

signal move_finished
signal unit_attacked

var unit:Unit setget set_unit
func set_unit(value:Unit):
	clear_unit_path()
	unit = value


var _unit_path:Curve2D = Curve2D.new()
var _unit_target:Vector2 = Vector2()

func add_unit_path_point(point:Vector2):
	if _unit_path == null:
		return
		
	if get_unit_path_point_count() <= 1:
		_unit_path.add_point(point)
	else:
		_unit_path.add_point(point)
		
		var mid_idx = get_unit_path_point_count() - 2
		
		var left = _unit_path.get_point_position(mid_idx-1)
		var mid = _unit_path.get_point_position(mid_idx)
		var right = _unit_path.get_point_position(mid_idx+1)
		
		
		var n1 = (left-mid).normalized()
		var n2 = (right-mid).normalized()
		
		var normal = (n1+n2).tangent().normalized()
		
		var t = pow(min((left-mid).length(), (right-mid).length()), 1/1.5)
		
		if (mid+normal-right).length() > (mid-normal-right).length():
			_unit_path.set_point_in(mid_idx, normal*t)
			_unit_path.set_point_out(mid_idx, -normal*t)
		else:
			_unit_path.set_point_in(mid_idx, -normal*t)
			_unit_path.set_point_out(mid_idx, normal*t)
	
	
func clear_unit_path():
	_unit_path.clear_points()
	
	
func get_unit_path_point_count():
	return _unit_path.get_point_count()
	
func go_path():
	unit.move_along_path(_unit_path)
	
	yield(unit, "move_finished")
	
	if _grid_node and _unit_path.get_point_count() > 0:
		unit.map_position = _grid_node.world_to_map(_unit_path.get_point_position(_unit_path.get_point_count()-1))
		
	clear_unit_path()
	emit_signal("move_finished")

func aim_to_point(global_position:Vector2):
	_unit_target = global_position

func get_global_aim():
	return _unit_target

func attack():
	unit.shoot_to_global(_unit_target)
	
	yield(unit, "attacked")
	
	emit_signal("unit_attacked")

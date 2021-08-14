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
var _visible_global_aim:Vector2 = Vector2()
var _aim_damage_cell:Vector2 = Vector2()



func can_move():
	return _unit_path.get_point_count() > 0


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
		
		var normal 
		
		if (n1+n2).length() < 0.01: # при очень маленьких искривлениях нормаль посчитается неверно и будет дефект
			normal = Vector2()
		else:
			normal = (n1+n2).tangent().normalized()
			
		var t = min((left-mid).length(), (right-mid).length()) * 0.2
		
		if (mid+normal-right).length() > (mid-normal-right).length():
			_unit_path.set_point_in(mid_idx, normal*t)
			_unit_path.set_point_out(mid_idx, -normal*t)
		else:
			_unit_path.set_point_in(mid_idx, -normal*t)
			_unit_path.set_point_out(mid_idx, normal*t)
	
	
func get_baked_path_points():
	return _unit_path.get_baked_points()
	
	
func clear_unit_path():
	_unit_path.clear_points()
	
	
func get_unit_path_point_count():
	return _unit_path.get_point_count()
	
	
func clear_settings():
	_unit_path.clear_points()
	_aim_damage_cell = Vector2()
	unit = null
	
	
func go_path():
	unit.move_along_path(_unit_path)
	
	yield(unit, "move_finished")
	
	unit.map_position = _grid_node.global_world_to_map(unit.global_position)
	
	clear_unit_path()
	emit_signal("move_finished")


func set_visible_aim(global_position:Vector2):
	_visible_global_aim = global_position

func get_visible_aim():
	return _visible_global_aim

func aim_to_cell(cell:Vector2):
	_aim_damage_cell = cell

func get_aimed_cell():
	return _aim_damage_cell

func attack():
	unit.shoot_to_global(_visible_global_aim)
	
	yield(unit, "attacked")
	
	emit_signal("unit_attacked")

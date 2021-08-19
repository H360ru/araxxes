extends Node

class_name Player

export(NodePath) var grid_node_path

signal unit_move_finished
signal unit_attacked

var unit:Unit setget set_unit, get_unit
#######################################
func set_unit(value:Unit):
	unit = value
func get_unit() -> Unit:
	return unit
#######################################

# todo: возможно, сделать для перемещения и атаки отдельные классы, для более простого взаимодействия
var unit_pixel_path:PoolVector2Array # содержит центры всех ячеек пути 
var unit_move_target_cell:Vector2 # конечная ячейка пути

var unit_attack_target_cell:Vector2 # ячейка нанесения урона
var unit_attack_aim_pixel:Vector2 # чисто визульное представление места атаки


func prepare_move_along_path(pixel_path:PoolVector2Array):
	unit_pixel_path = pixel_path

func set_move_target_cell(cell:Vector2):
	unit_move_target_cell = cell

func has_path():
	return len(unit_pixel_path) > 1

func get_path_length():
	return len(unit_pixel_path)


func aim_unit_to_pixel(pixel:Vector2):
	unit_attack_aim_pixel = pixel

func set_aim_cell(cell:Vector2):
	unit_attack_target_cell = cell

func get_shoot_cost():
	return unit.weapon.shoot_action_cost


func start_move():
	
	if unit == null:
		printerr("Player has no unit to move")
		return
		
	unit.connect("move_finished", self, "_on_unit_move_finished", [], CONNECT_ONESHOT)
	
	unit.move_along_global_path(unit_pixel_path)
	
func start_attack():
	
	if unit == null:
		printerr("Player has no unit to attack")
		return
		
	unit.connect("attacked", self, "_on_unit_attacked", [], CONNECT_ONESHOT)
	
	unit.attack_to_global(unit_attack_aim_pixel)


func _on_unit_move_finished():
	emit_signal("unit_move_finished")
	_clear_move_settings()
	
func _on_unit_attacked():
	emit_signal("unit_attacked")
	_clear_attack_settings()

func _clear_move_settings():
	unit_pixel_path = PoolVector2Array()
	
func _clear_attack_settings():
	pass

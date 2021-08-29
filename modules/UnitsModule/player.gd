extends Node

class_name Player

export(NodePath) var grid_node_path

signal unit_move_finished
signal unit_attacked

var unit:Unit setget set_unit, get_unit
#######################################
func set_unit(value:Unit):
	if value == unit:
		return
	unit = value
	_clear_attack_settings()
	_clear_move_settings()
	
func get_unit() -> Unit:
	return unit
#######################################

var move_settings:UnitMove
var aim_settings:UnitAim


func prepare_to_move(unit_move:UnitMove):
	move_settings = unit_move
	
func prepare_to_aim(unit_aim:UnitAim):
	aim_settings = unit_aim


func start_move():
	if unit == null:
		printerr("Player has no unit to move")
		return
	
	if move_settings == null:
		printerr("Player has no path to move")
		return
		
	unit.connect("move_finished", self, "_on_unit_move_finished", [], CONNECT_ONESHOT)
	
	unit.move_by_unit_move(move_settings)
	
func start_attack():
	if unit == null:
		printerr("Player has no unit to attack")
		return
		
	if aim_settings == null:
		printerr("Player has no aim to shoot")
		return
		
	unit.connect("attacked", self, "_on_unit_attacked", [], CONNECT_ONESHOT)
	
	unit.attack_by_unit_aim(aim_settings)

func get_shoot_cost():
	return unit.weapon.shoot_action_cost

func _on_unit_move_finished():
	emit_signal("unit_move_finished")
	
	_clear_move_settings()
	
func _on_unit_attacked():
	emit_signal("unit_attacked")
	
	_clear_attack_settings()

func _clear_move_settings():
	move_settings = null
	
func _clear_attack_settings():
	aim_settings = null

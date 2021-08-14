extends Node2D

class_name UnitsGroup


signal unit_destroyed(unit)
signal unit_created(unit)

signal unit_damaged(unit, by)
signal unit_out_of_health(unit)

signal unit_acted(unit, by)
signal unit_exhausted(unit)

export(NodePath) var navigation_grid_path

onready var _grid:NavigationGrid = get_node_or_null(navigation_grid_path)

func create_unit(unit:PackedScene, cell:Vector2, group:String=""):
	if _grid == null:
		printerr("Can't create unit without NavigationGrid instance")
		return
		
	var inst:Unit = unit.instance() as Unit
	
	inst.map_position = cell
	inst.global_position = _grid.get_cell_center_global(cell)
	
	inst.connect("damaged", self, "_on_unit_damaged", [inst])
	inst.connect("out_of_health", self, "_on_unit_out_of_health", [inst])
	inst.connect("exhausted", self, "_on_unit_exhausted", [inst])
	inst.connect("acted", self, "_on_unit_acted", [inst])
	
	add_child(inst)
	
	if group != "":
		inst.add_to_group(group)
	
	emit_signal("unit_created")
	
func destroy_unit(unit:Unit):
	unit.queue_free()
	
	emit_signal("unit_destroyed")
	
func get_all_units() -> Array:
	return get_children()
	
func get_units_in_group(group:String):
	return get_tree().get_nodes_in_group(group)
	
func get_occupied_cells() -> PoolVector2Array:
	var res:PoolVector2Array = PoolVector2Array()
	for i in get_all_units():
		res.append(i.map_position)
		
	return res
	
func get_occupied_cells_by_group(group:String):
	var res:PoolVector2Array = PoolVector2Array()
	for i in get_units_in_group(group):
		res.append(i.map_position)
	
	return res
	
func get_unit_on_cell(cell:Vector2) -> Unit:
	for i in get_all_units():
		if i.map_position == cell:
			return i
	return null
	
func damage_unit_at_cell(cell:Vector2, damage:int):
	var unit:Unit = get_unit_on_cell(cell)
	if unit != null:
		unit.damage(damage)
	
func get_surrounding_units_cells(unit:Unit):
	var res:PoolVector2Array = PoolVector2Array()
	for i in get_all_units():
		if i != unit:
			res.append(i.map_position)
			
	return res
	
	
func _on_unit_damaged(by:int, unit:Unit):
	emit_signal("unit_damaged", unit, by)
	print(unit, " damaged by ", by, " health balance ", unit.health)
	
func _on_unit_out_of_health(unit:Unit):
	emit_signal("unit_out_of_health", unit)
	print(unit, " out of health")
	
func _on_unit_acted(by:int, unit:Unit):
	emit_signal("unit_acted", unit, by)
	
func _on_unit_exhausted(unit:Unit):
	emit_signal("unit_exhausted")
	

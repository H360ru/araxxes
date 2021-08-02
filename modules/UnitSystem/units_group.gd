extends Node2D

class_name UnitsGroup

signal unit_damaged(unit)
signal unit_deleted(unit)
signal unit_created(unit)
signal unit_out_of_health(unit)

export(NodePath) var navigation_grid_path

onready var _grid:NavigationGrid = get_node_or_null(navigation_grid_path)

func create_unit(unit:PackedScene, cell:Vector2):
	if _grid == null:
		printerr("Can't create unit without NavigationGrid instance")
		return
		
	var inst:Unit = unit.instance() as Unit
	inst.map_position = cell
	inst.global_position = _grid.get_cell_center_global(cell)
	
	inst.connect("damaged", self, "_on_unit_damaged", [inst])
	inst.connect("out_of_health", self, "_on_unit_out_of_health", [inst])
	
	add_child(inst)
	
	emit_signal("unit_created")
	
func destroy_unit(unit:Unit):
	if unit.is_connected("damaged", self, "_on_unit_damaged"):
		unit.disconnect("damaged", self, "_on_unit_damaged")
	if unit.is_connected("out_of_health", self, "_on_unit_out_of_health"):
		unit.disconnect("out_of_health", self, "_on_unit_out_of_health")
		
	unit.queue_free()
	
	emit_signal("unit_deleted")
	
func get_all_units() -> Array:
	return get_children()
	
func get_occupied_cells() -> PoolVector2Array:
	var res:PoolVector2Array = PoolVector2Array()
	for i in get_all_units():
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
	
func _on_unit_damaged(unit:Unit):
	emit_signal("unit_damaged", unit)
	
func _on_unit_out_of_health(unit:Unit):
	emit_signal("unit_out_of_health", unit)
	

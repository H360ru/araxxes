extends Node2D

class_name UnitsGroup

export(NodePath) var navigation_grid_path

onready var _grid:NavigationGrid = get_node_or_null(navigation_grid_path)

func create_unit(unit:PackedScene, cell:Vector2):
	if _grid == null:
		printerr("Can't create unit without NavigationGrid instance")
		return
		
	var inst:Unit = unit.instance() as Unit
	inst.map_position = cell
	inst.global_position = _grid.get_cell_center_global(cell)
	
	add_child(inst)
	
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
	
func get_units_in_area(area:PoolVector2Array) -> Array:
	var res:Array = []
	for i in get_all_units():
		if i.pos in area:
			res.append(i)
	return res
	

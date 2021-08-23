extends Node

class_name Bot

export(NodePath) var units_node
export(NodePath) var grid_node

onready var units:UnitsGroup = get_node_or_null(units_node)
onready var grid:NavigationGrid = get_node_or_null(grid_node)

signal turn_made(unit)

func make_turn(unit:Unit, group_to_attack:String):
	pass
	var target_unit:Unit
	var queue:Array = [unit.map_position]
	var costs = {unit.map_position:0}
	# нереально грязный пример наитупейшего юнита,
	# он служит только для демонстрации архитектуры.
	# возможны баги, даже не отлаживал
	while not queue.empty():
		var curr:Vector2 = queue.pop_front()
		
		var cell_unit = units.get_unit_on_cell(curr)
		if cell_unit != null and units.is_unit_in_group(cell_unit, group_to_attack):
			target_unit = cell_unit
			break
			
		for i in grid.get_cell_neighbors(curr):
			var new_cost = costs[curr]+1
			
			if not i in costs or new_cost < costs[i]:
				queue.append(i)
				costs[i] = new_cost
	
	var obsts:Array = units.get_surrounding_units_cells(unit)
	obsts.erase(target_unit.map_position)
	var path = grid.find_pixel_path(unit.map_position, target_unit.map_position, obsts, true) as Array
	if len(path)-1 > unit.action_points:
		path = path.slice(0, unit.action_points)
		
	unit.move_along_global_path(path)
	yield(unit, "move_finished")
	unit.act(len(path)-1)
	unit.map_position = grid.global_world_to_map(unit.global_position)
	emit_signal("turn_made", unit)
	

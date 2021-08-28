extends Node2D

export(NodePath) var grid_path
export(NodePath) var player_path
export(NodePath) var units_path
export(NodePath) var control_path

onready var grid:NavigationGrid = get_node_or_null(grid_path)
onready var player:Player = get_node_or_null(player_path)
onready var units:UnitsGroup = get_node_or_null(units_path)
onready var control = get_node_or_null(control_path)

func _process(delta):
	update()
	
func _draw():
	if player != null and player.unit != null:
		draw_circle(player.unit.global_position-global_position, 25.0, Color(0.0, 1.0, 0.0, 0.3))
		
	for i in units.get_units_in_group(control.player_group):
		draw_circle(to_local(grid.get_cell_center_global(i.map_position)), 15.0, Color.green if i.is_active() else Color.black)
		
	for i in units.get_units_in_group(control.enemy_group):
		draw_circle(to_local(grid.get_cell_center_global(i.map_position)), 15.0, Color.red if i.is_active() else Color.black)
	
	if len(player.unit_pixel_path) > 0:
		draw_polyline(player.unit_pixel_path, Color.green, 2.0, true)
		
	match control.state:
		control.States.READY:
			for i in control.move_area:
				draw_circle(grid.get_cell_center_global(i), 10.0, Color(0.0, 1.0, 0.0, 0.3))
		control.States.TARGETING:
			draw_line(player.unit.global_position, player.unit_attack_aim_pixel, Color.red, 2.0, true)
			draw_circle(grid.get_cell_center_global(player.unit_attack_target_cell), 10.0, Color.red)

extends Node

var robot:PackedScene = preload("res://tests/unit_system_new_new/Unit1.tscn")

onready var units:UnitsGroup = $"../Units"
onready var grid:NavigationGrid = $"../Grid"
onready var player:Player = $"../Player"
onready var bot:Bot = $"../Bot"

const player_group = "team"
const enemy_group = "enemies"

enum States{
	WAIT_PLAYER,
	READY,
	TARGETING,
	
}

var state:int
var current_group = player_group
var move_area:PoolVector2Array = PoolVector2Array()

func SReady():
	state = States.READY
	if player != null and player.unit != null:
		move_area = grid.get_map_distance_area(player.unit.map_position, player.unit.action_points, units.get_surrounding_units_cells(player.unit))
	
func SWaitPlayer():
	state = States.WAIT_PLAYER
	
func STargeting():
	state = States.TARGETING

func _ready():
	SReady()

func _process(delta):
	var mouse_cell = grid.global_world_to_map(grid.get_global_mouse_position())
	if current_group != player_group:
		return
	match state:
		States.READY:
			if Input.is_action_just_pressed("mouse_left"):
				var unit = units.get_unit_on_cell(mouse_cell)
				if unit and unit.is_in_group(current_group) and unit.is_active():
					player.unit = unit
					move_area = grid.get_map_distance_area(player.unit.map_position, player.unit.action_points, units.get_surrounding_units_cells(player.unit))
					
				elif player.unit != null:
					if mouse_cell in move_area:
						var path = grid.find_pixel_path(player.unit.map_position, mouse_cell, units.get_surrounding_units_cells(player.unit), true)
						player.prepare_move_along_path(path)
						player.set_move_target_cell(mouse_cell)
				
			if Input.is_action_just_pressed("mouse_right"):
				if player.unit != null and player.unit.can_shoot():
					STargeting()
				else:
					print("Not enough action points to shoot")
			
			if Input.is_action_just_pressed("ui_left"):
				if player.unit == null:
					return
				player.unit.disable()
				player.unit = null
				move_area = PoolVector2Array()
				
			if Input.is_action_just_pressed("ui_right"):
				for i in units.get_all_units():
					i.enable()
			
			if Input.is_action_just_pressed("ui_focus_next"):
				next_turn()
			
			if Input.is_action_just_pressed("ui_select"):
				if player.unit != null and player.has_path():
					player.start_move()
					SWaitPlayer()
		
		States.TARGETING:
			var p = grid.get_obstacle_intersection(player.unit.map_position, mouse_cell, units.get_surrounding_units_cells(player.unit), -1, true, 5)
			var c = grid.get_map_obstacle_intersection(player.unit.map_position, mouse_cell, units.get_surrounding_units_cells(player.unit), -1)
			
			player.set_aim_cell(c)
			player.aim_unit_to_pixel(p)
			
			if Input.is_action_just_pressed("ui_select"):
				player.start_attack()
				SWaitPlayer()
				
			if Input.is_action_just_pressed("mouse_right"):
				SReady()

func next_turn():
	current_group = player_group if current_group == enemy_group else enemy_group
	move_area = PoolVector2Array()
	player.unit = null
	units.restore_points_all_units()
	if current_group == enemy_group:
		for i in units.get_units_in_group(enemy_group):
			bot.make_turn(i, player_group)
			yield(bot, "turn_made")
		current_group = player_group
	

func _on_Player_unit_move_finished():
	player.unit.act(player.get_path_length()-1)
	player.unit.map_position = player.unit_move_target_cell
	player.unit.global_position = grid.get_cell_center_global(player.unit_move_target_cell)
	
	SReady()

func _on_Player_unit_attacked():
	units.damage_unit_at_cell(player.unit_attack_target_cell, player.unit.weapon.damage)
	player.unit.act(player.get_shoot_cost())
	
	SReady()

func _on_Field_ready():
	units.create_unit(robot, Vector2(3, 3), player_group)
	units.create_unit(robot, Vector2(9, 6), player_group)
	units.create_unit(robot, Vector2(3, 9), enemy_group)

func _on_Units_unit_out_of_health(unit):
	units.destroy_unit(unit)

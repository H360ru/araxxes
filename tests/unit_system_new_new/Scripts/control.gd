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
						var unit_move:UnitMove = UnitMove.new()
						unit_move.global_pixel_path = path
						unit_move.target_cell = mouse_cell
						unit_move.move_cost = len(path)-1
						player.prepare_to_move(unit_move)
				
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
				if player.unit != null and player.move_settings != null:
					player.start_move()
					SWaitPlayer()
		
		States.TARGETING:
			var p = grid.get_obstacle_intersection(player.unit.map_position, mouse_cell, units.get_surrounding_units_cells(player.unit), -1, true, 5)
			var c = grid.get_map_obstacle_intersection(player.unit.map_position, mouse_cell, units.get_surrounding_units_cells(player.unit), -1)
			
			var t = UnitAim.new()
			
			t.global_pixel_aim = p
			t.cell_to_damage = c
			t.shoot_cost = player.get_shoot_cost()
			
			player.prepare_to_aim(t)
			
			
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
	player.unit.act(player.move_settings.move_cost)
	player.unit.map_position = player.move_settings.target_cell
	player.unit.global_position = grid.get_cell_center_global(player.move_settings.target_cell)
	
	SReady()

func _on_Player_unit_attacked():
	units.damage_unit_at_cell(player.aim_settings.cell_to_damage, player.unit.weapon.damage)
	player.unit.act(player.aim_settings.shoot_cost)
	
	SReady()

func _on_Field_ready():
	units.create_unit(robot, Vector2(3, 3), player_group)
	units.create_unit(robot, Vector2(9, 6), player_group)
	units.create_unit(robot, Vector2(3, 9), enemy_group)

func _on_Units_unit_out_of_health(unit):
	units.destroy_unit(unit)

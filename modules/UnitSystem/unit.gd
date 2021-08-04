extends Node2D

class_name Unit

export(Resource) var weapon
export(int, 1, 10_000) var max_health
export(int, 1, 10_000) var move_distance

signal move_finished
signal attacked
signal out_of_health
signal out_of_move
signal damaged
signal move_deducted

var map_position:Vector2

var health:int
var move_remains:int

func _ready():
	health = max_health
	move_remains = move_distance

func move_along_path(path:Curve2D):
	emit_signal("move_finished")

func shoot_to_global(global_pos:Vector2):
	emit_signal("attacked")

func damage(by:int):
	health -= by
	emit_signal("damaged")
	if health <= 0:
		health = 0
		emit_signal("out_of_health")
		

func can_move_by(by:int):
	return move_remains >= by

func deduct_move(by:int):
	move_remains -= by
	emit_signal("move_deducted")
	if move_remains <= 0:
		move_remains = 0
		emit_signal("out_of_move")

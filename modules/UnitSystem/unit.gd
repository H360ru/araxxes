extends Node2D

class_name Unit

export(Resource) var weapon
export(int, 1, 10_000) var max_health

signal move_finished
signal attacked
signal out_of_health
signal damaged

var map_position:Vector2

var health:int
var move_remains:int

func _ready():
	health = max_health

func move_along_path(path:Curve2D):
	emit_signal("move_finished")

func shoot_to_global(global_pos:Vector2):
	emit_signal("attacked")

func damage(by:int):
	health -= by
	if health <= 0:
		health = 0
		emit_signal("out_of_health")
		
	emit_signal("damaged")

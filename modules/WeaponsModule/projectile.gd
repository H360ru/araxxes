extends Node2D

class_name Projectile

signal launched
signal moved

func fly_between_globals(global_pos1:Vector2, global_pos2:Vector2):
	emit_signal("moved")

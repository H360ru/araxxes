extends Area2D


# Declare member variables here. Examples:
# var a = 2
#func _input(event):
##	prints(viewport, event, shape_idx)
#	if event is InputEventMouseButton:
#		if Input.is_action_just_pressed("click"):
#			print('SELECT')
#			get_parent().selected = !get_parent().selected
#			get_tree().set_input_as_handled()

func _input_event(viewport, event, shape_idx):
#	prints(viewport, event, shape_idx)
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			print('SELECT')
			get_parent().SOUND.play_bgm("ui_deny")
			get_parent().selected = !get_parent().selected
			get_tree().set_input_as_handled()

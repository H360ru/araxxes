extends Control

#TO_DO: удалить скрипт или зарефакторить
class_name ui_screen

onready var _tween = Global.TWEEN#get_node('Tween')

onready var pos = Vector2.ZERO#-rect_global_position#rect_position

# Declare member variables here. Examples:
export(NodePath) var parent

func _unhandled_input(event):
	if event.is_action_pressed("click"):
#		grab_focus()
#		print('grab_focus')
		_ui_release_focus()
#		print(get_parent_control().name)

func _ui_release_focus():
	var f = get_focus_owner()
#	print(f.name, ' focus_owner Self: ', self.name)
	if f != null:
		f.release_focus()
#	_anim(get_node(parent))
#	_anim_test()
#		_anim(self, true)
#		yield(_tween,"tween_completed")
#		print(get_parent().name)
		get_parent()._back()

func _anim(node: Control, reverse = false):
	#TO_DO: смещение стартовой при повторных вызовах во время исполнения
	node.visible = true
	var duration = 0.3
	var direction = Vector2(1000, 0)
#	var pos = node.rect_position
	if reverse:
		_tween.interpolate_property(node, "rect_position",
		pos, pos + direction, duration,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	else:
		_tween.interpolate_property(node, "rect_position",
		pos + direction, pos + Vector2(0, 0), duration,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	_tween.start()
#	_ui_release_focus()
#	_settings_menu.grab_focus()

func _anim_test():
	var node = get_parent().get_node("MenuContainer")
	var duration = 0.3
#	var pos = node.rect_position
	_tween.interpolate_property(node, "rect_position", pos - Vector2(1000, 0),
	pos, duration,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	_tween.start()

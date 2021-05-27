#extends Control
#
#
## Declare member variables here. Examples:
#var container_path = "MenuContainer/VBoxContainer/"
#onready var _play_button = get_node(container_path+"Играть")
#onready var _settings_button = get_node(container_path+"Настройки")
#onready var _exit_button = get_node(container_path+"Выйти")
#
#onready var _settings_menu = get_node("TabContainer")
#onready var _tween = get_node("Tween")
#
#onready var pos = rect_position
#
## Called when the node enters the scene tree for the first time.
#func _ready():
##	TranslationServer.set_locale('en')
#	_play_button.connect("button_down", self, '_on_play')
#	_settings_button.connect("button_down", self, '_on_settings')
#	_exit_button.connect("button_down", self, '_on_exit')
#	get_tree().call_group('ui', 'print_name')
#
#
#
#func _on_play():
#	_ui_change_scene()
#
#func _on_settings():
#	_anim(_settings_menu)
#	_anim_test()
#
#func _anim(node: Control):
#	#TODO: смещение стартовой при повторных вызовах во время исполнения
#	node.visible = true
#	var duration = 0.3
##	var pos = node.rect_position
#	_tween.interpolate_property(node, "rect_position",
#	pos + Vector2(1000, 0), pos + Vector2(0, 0), duration,
#	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	_tween.start()
#	_ui_release_focus()
##	_settings_menu.grab_focus()
#
#func _anim_test():
#	var node = $MenuContainer
#	var duration = 0.3
#	var pos = node.rect_position
#	_tween.interpolate_property(node, "rect_position",
#	pos, pos - Vector2(1000, 0), duration,
#	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	_tween.start()
#
#func _on_exit():
#	_ui_exit()
#
#func _ui_change_scene(test_path = "res://Scenes/Game.tscn"):
#	get_tree().change_scene(test_path)
#
#func _ui_exit():
#	get_tree().quit()
#
#func _ui_pause_toggle():
#	get_tree().paused = !get_tree().paused
#
#func _ui_release_focus():
#	var f = get_focus_owner()
#	if f != null:
#		f.release_focus()
#		_anim(f)
#
#
#func _gui_input(event):
##	if event.is_action_pressed("click"):
#	print(event)
#
##func _unhandled_input(event):
##	if event.is_action_pressed("click"):
###		grab_focus()
###		print('grab_focus')
##		_ui_release_focus()
###		var f = get_focus_owner()
###		if f != null:
###			f.release_focus()

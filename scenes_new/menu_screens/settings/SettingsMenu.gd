extends ui_screen

#var container_path = "MenuContainer/VBoxContainer/"
#onready var _play_button = get_node(container_path+"Играть")
onready var _controls_button = get_node("Настройки/VBoxContainer/Управление")
onready var _exit_button = get_node("Настройки/VBoxContainer/Выйти2")
#onready var _exit_button = get_node(container_path+"Выйти")

#onready var _settings_menu = get_node("TabContainer")
#onready var _tween = get_node("Tween")

#onready var pos = rect_position

# Called when the node enters the scene tree for the first time.
func _ready():
#	TranslationServer.set_locale('en')
#	_play_button.connect("button_down", self, '_on_play')
#	_settings_button.connect("button_down", self, '_on_settings')
	_controls_button.connect("button_down", self, '_on_controls')
	_exit_button.connect("button_down", self, '_on_exit')
#	get_tree().call_group('ui', 'print_name')
#	get_parent().get_parent().connect("resized", self, "size_test")

func size_test():
	if get_parent().get_parent().rect_size.x < 400:
		get_parent().get_parent().get_parent().change_control(load("res://Scenes/Screen2.tscn"))

func _on_controls():
	get_parent().get_parent().get_parent()._to_child_name("Управление")
	
func _on_exit():
#	var check = yield(get_parent().get_parent().get_parent().call_popup(), 'completed')
#	if check.has('confirmed'):
#		get_parent().get_parent().get_parent()._back()
	if Global.SETTINGS.changed:
		get_parent().get_parent().get_parent().wait_popup_for('save_and_back', ['Сохранить', 'Не сохранять'], 0)# ['confirmed'])
	else:
		get_parent().get_parent().get_parent()._back()

func _on_CheckBox_toggled(button_pressed):
	Global.MOUSE.toggle_cursor(!button_pressed)


func _on_Default_pressed():
	Global.SETTINGS.load_settings()

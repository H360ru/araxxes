extends ui_screen

#var container_path = "MarginContainer/MarginContainer/VBoxContainer/"
##onready var _play_button = get_node(container_path+"Играть")
#onready var _settings_button = get_node(container_path+"Настройки")
#onready var _help_button = get_node(container_path+"Помощь")
##onready var _exit_button = get_node(container_path+"Выйти")
#
##onready var _settings_menu = get_node("TabContainer")
##onready var _tween = get_node("Tween")
#
#func _ready():
##	_play_button.connect("button_down", self, '_on_play')
#	_settings_button.connect("button_down", self, '_on_settings')
#	_help_button.connect("button_down", self, '_on_help')
##	_exit_button.connect("button_down", self, '_on_exit')

func _on_play():
	pass

func _on_settings():
	get_parent()._to_child_ind(0)
	Global.SOUND.play()

func _on_help():
	get_parent()._to_child_name('Помощь')

#HACK: сделать через нормальный метод глобала
func _on_exit():
	get_tree().quit()

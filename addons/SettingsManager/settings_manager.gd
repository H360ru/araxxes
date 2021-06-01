extends Node
# @todo #9 Класс обработки примененных настроек
class_name SettingsManager

# GAME SETTINGS
var local: String# = 'en'

var game_speed: int = 3 # множитель скорости

var cursor_texture = "res://Assets/cursor_45.png"
var cursor = "res://addons/MouseManager/cursor_node/Cursor.tscn"
var use_os_cursor: bool = false
var cursor_size: float = 0.4

# VIDIO SETTINGS
var brightness: float = 255
var contrast: float
var ui_tint: Color
var b = "text"
var window_size: Vector2 = Vector2(1024, 600)
var fullscreen: bool
var resolution: Vector2 = Vector2(1024, 600)

# SOUND SETTINGS
var sound_volume: float = 0

#SYSTEM PROPERTY
# чек пользовательских изменений. Задавать только из вызовов интерфейсов или консольных команд
# (не при загрузке сейва)
#TO_DO: подумать над рефакторингом
var changed: bool = false

#TO_DO: ближе к альфе добавить сейвам версию и грамотный обработчик конфликтов

#TO_DO: передавать ссылку конфигов инициализации
#func _init(settings_file):
#	print('property_list:')
##	for i in get_property_list():
##		print(i)#['name'])
##	print(get_settings())
#
#	#BUG: вызывало дублирование курсора 
##	set_settings(get_settings())

# Main setter interface
func set_value(property, value):
	prints('Property test:', property, value)
	
	#TO_DO: проверку на существование переменной
	set(property, value)
	
	#поведение при присваивании
	match property:
		'brightness':
			Global.environment.set_adjustment_brightness(value/255)
		'window_size':
			OS.window_size = value
			OS.center_window()
		'resolution':
			Global.get_viewport().size = value
			if !fullscreen:
				OS.window_size = value
				OS.center_window()
		'fullscreen':
			OS.set_window_fullscreen(value)
#			resolution = Global.get_viewport().size
		'local':
			TranslationServer.set_locale(value)
		#TO_DO: удалить текстуру курсора
		'cursor_texture':
			Global.MOUSE.set_cursor_texture(load(value))
		'cursor':
			Global.MOUSE.func_queue = Global.MOUSE.change_cursor(value)
		'use_os_cursor':
			if value:
				Global.MOUSE.delete_cursor_instance()
			else:
				Global.MOUSE.func_queue = Global.MOUSE.change_cursor()
		'cursor_size':
			Global.MOUSE.func_queue = Global.MOUSE.change_cursor()
		'sound_volume':
			Global.SOUND.set_volume(value)
		'changed':
			pass
		_:
			printerr(property, ' property not found')
			print_debug(property, ' property not found')
	return "Property test"


func load_settings(CONFIG_DIR = "user://saves/", CONFIG_FILE_NAME = "default", CONFIG_EXTENSION = ".tres"):
	if !ResourceLoader.exists("res://saves/default.tres"):
		print(CONFIG_DIR + CONFIG_FILE_NAME + CONFIG_EXTENSION)
		return false
	
	var new_load:Resource = ResourceLoader.load("res://saves/default.tres", 'Resource', true)
	self.set_settings(new_load.settings)
	print("load_settings")
	return true

func get_settings() -> Dictionary:
	var settings = {}
	for i in get_script().get_script_property_list():
		settings[i['name']] = get(i['name'])
	
	#TO_DO: возможно следует как-то иначе сделать логику постобработки сейва
	# пока вот такой костыль
	#!!!ERASE SYSTEM PROPERTYS!!!
	settings.erase('changed')
	#!!!
	return settings

func set_settings(settings:Dictionary ):
	for i in settings.keys():
		print(i)
		set_value(i, settings[i])



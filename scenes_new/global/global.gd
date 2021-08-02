extends CanvasLayer

class_name GlobalTest

# Declare member variables here. Examples:
onready var environment = get_node("WorldEnvironment").get_environment()
onready var TWEEN = get_node("Tween")
var SETTINGS = SettingsManager.new()
onready var SOUND = SoundManager.new()#$AudioStreamPlayer
onready var MOUSE = MouseManager.new()

func _init():
	#print("GLOBAL INIT")
	#print(SETTINGS)
	initialisation()
	
#	connect()
	#TODO: загрузка инициализирующих настроек до\взамен загрузки основного профиля

#Обработчик системных/служебных нотификаций (согласно конфигам ос)
#TODO: NOTIFICATION_CRASH
func _notification(what: int):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		#ProjectSettings.set_setting("application/config/auto_accept_quit", false)
		#get_tree().set_auto_accept_quit(false)
#		#print('Сохранить изменения???????????????????????????????????????????????')
#		OS.request_attention()
#		OS.alert('Сохранить изменения?', "Выход из игры")
		get_tree().quit()
		#dump_settings_to_tmp()
#		yield()

func initialisation(_cmdline_args = null):
	#print("Cmdline args: ", OS.get_cmdline_args())
	if OS.has_feature("JavaScript"):
		js_initialisation()
	#system_check()

# HACK
func js_initialisation():
	var _node = load("res://web/js_system_check.gd").new()#instance()
	_node.name = 'JavaScriptUtils' # надо бы название получше
	add_child(_node)

func system_check():
	var feature_arr = ["Android", "HTML5", "JavaScript", "OSX", "iOS", "UWP", "Windows", "X11",\
	 "Server", "debug", "release", "editor", "standalone", "64", "32", "x86_64", "x86", "arm64",\
	 "arm", "mobile", "pc", "web", "etc", "etc2", "s3tc", "pvrtc"]
	for i in feature_arr:
		print(i,': ', OS.has_feature(i))
	
	#print('Model name: ', OS.get_model_name())
	
	#print('Property list:')
	for i in OS.get_property_list():
		print(i['name'],': ', OS.get(i['name']))#i['usage'])
	
	#print("Allowed threads use: ", OS.can_use_threads())
	#print("Threads count: ", OS.get_processor_count())
	
#	if OS.screen_orientation == OS.SCREEN_ORIENTATION_LANDSCAPE:
#	get_screen_orientation()

# Called when the node enters the scene tree for the first time.
func _ready():
#	#print('OS.is_userfs_persistent: ', OS.is_userfs_persistent())

	MOUSE.toggle_cursor(true)
	
	add_child(SOUND)

#TODO: сделать понятнее интерфейс
func get_screen_orientation() -> float:
#	if OS.screen_orientation%2 == 0:
#		#print("Альбомная ориентация")
#	else:
#		#print('Портретная ориентация')
	var s = get_viewport().size
	if s.y == 0:
		printerr("ZERO DIVISION!!!!")
	return (s.x / s.y)

#func _exit_tree():
#	SettingsSaveLoad.save_settings()


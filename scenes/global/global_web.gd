extends CanvasLayer
#TODO: #12 Глобальный класс отвечающий за
#  инициализацию всех модулей, обработку системных событий
#  согласно предустановленным конфигам системы
#  и аргументам командной строки

#class_name Global

onready var environment = get_node("WorldEnvironment").get_environment()
onready var TWEEN = get_node("Tween")
var SETTINGS = SettingsManager.new()
onready var SOUND = SoundManager.new()
onready var MOUSE = MouseManager.new()

func _init():
	print("GLOBAL INIT")
	initialisation()

func _ready():
	MOUSE.toggle_cursor(true)
	
	add_child(SOUND)
	printerr('WebBuild export!!!!')
	yield(get_tree(), "idle_frame")
	Console.write_line('WebBuild export!!!!')

	#TODO: #31 загрузка инициализирующих настроек до\взамен загрузки основного профиля

#Обработчик системных/служебных нотификаций (согласно конфигам ос)
#TODO: #32 NOTIFICATION_CRASH
func _notification(what: int):
	match what:
		NOTIFICATION_WM_QUIT_REQUEST:
			#ProjectSettings.set_setting("application/config/auto_accept_quit", false)
			#get_tree().set_auto_accept_quit(false)
	#		print('Сохранить изменения???????????????????????????????????????????????')
	#		OS.request_attention()
	#		OS.alert('Сохранить изменения?', "Выход из игры")
			get_tree().quit()
			#dump_settings_to_tmp()
	#		yield()
		NOTIFICATION_WM_FOCUS_IN:
			SOUND.set_volume(0)
		NOTIFICATION_WM_FOCUS_OUT:
			SOUND.set_volume(-400)

func initialisation(cmdline_args = null):
	print("Cmdline args: ", OS.get_cmdline_args())
	# system_check()

func system_check():
	var feature_arr = ["Android", "HTML5", "JavaScript", "OSX", "iOS", "UWP", "Windows", "X11",\
	 "Server", "debug", "release", "editor", "standalone", "64", "32", "x86_64", "x86", "arm64",\
	 "arm", "mobile", "pc", "web", "etc", "etc2", "s3tc", "pvrtc"]
	for i in feature_arr:
		print(i,': ', OS.has_feature(i))
	
	print('Model name: ', OS.get_model_name())
	
	print('Property list:')
	for i in OS.get_property_list():
		print(i['name'],': ', OS.get(i['name']))#i['usage'])
	
	print("Allowed threads use: ", OS.can_use_threads())
	print("Threads count: ", OS.get_processor_count())
	
#	if OS.screen_orientation == OS.SCREEN_ORIENTATION_LANDSCAPE:
#	get_screen_orientation()

#TODO: #30 сделать понятнее интерфейс
func get_screen_orientation() -> float:
#	if OS.screen_orientation%2 == 0:
#		print("Альбомная ориентация")
#	else:
#		print('Портретная ориентация')
	var s = get_viewport().size
	return (s.x / s.y)

#func _exit_tree():
#	SettingsSaveLoad.save_settings()

func is_html():
	return OS.has_feature("HTML5")


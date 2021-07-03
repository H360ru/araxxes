#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Modified code of Godot-GameTemplate
# Star original github project: https://github.com/nezvers/Godot-GameTemplate
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TODO: #13 Класс/библиотека отвечающая за загрузку, сохранение файлов
#  Стоит применить какой-то паттерн, например, дикоратор
#  чтобы отделить интерфейсы от реализации
extends Node
#TODO: #46 Рефакторинг интерфейсов
#var Save / Load
const CONFIG_DIR: = "user://saves/"#"res://saves/" #"user://saves/"
const CONFIG_FILE_NAME: = "settings"
const CONFIG_EXTENSION: = ".tres"#'.txt'#

#Save/ Load
#Call this method to trigger Settings saving - by default triggered on closing options menu
func save_settings()->void:
	save_settings_resource()
#	save_settings_JSON()

func load_settings()->bool:
	var loaded:bool
	loaded = load_settings_resource()
	#loaded = load_settings_JSON()
	return loaded

func load_settings_default()->bool:
	return load_settings_resource("res://saves/", 'default')

# Resource VARIATION - new version
func save_settings_resource()->void:
	var new_save: 			= SaveSettings.new()
	new_save.inputs 		= SettingsControls.get_input_data()
	SettingsControls.changed = false # UI UTIL PROPETRY
	new_save.settings		= Global.SETTINGS.get_settings()
	Global.SETTINGS.changed = false # UI UTIL PROPETRY
	
	var dir: = Directory.new()
	if not dir.dir_exists(CONFIG_DIR):
		dir.make_dir_recursive(CONFIG_DIR)
	ResourceSaver.save(CONFIG_DIR + CONFIG_FILE_NAME + CONFIG_EXTENSION, new_save)
#	ResourceSaver.save(CONFIG_DIR + CONFIG_FILE_NAME + CONFIG_EXTENSION, File.new())
	print('Save_settings_resource')
	print(new_save.settings)

func load_settings_resource(_CONFIG_DIR = CONFIG_DIR, _CONFIG_FILE_NAME = CONFIG_FILE_NAME, \
	_CONFIG_EXTENSION = CONFIG_EXTENSION)->bool:
	if !ResourceLoader.exists(_CONFIG_DIR + _CONFIG_FILE_NAME + _CONFIG_EXTENSION):
		return false
	
	print("Start Load_settings_resource")
	var new_load:Resource = ResourceLoader.load(_CONFIG_DIR + _CONFIG_FILE_NAME + _CONFIG_EXTENSION, 'Resource', true)
	if !new_load:
		return false

	SettingsControls.set_input_data(new_load.inputs)
	SettingsControls.changed = false # UI UTIL PROPETRY
	Global.SETTINGS.set_settings(new_load.settings)
	Global.SETTINGS.changed = false # UI UTIL PROPETRY
	print("Load_settings_resource")
	return true

func save_settings_config(settings: Dictionary, file_dir: String, file_name: String):
#	if !file_dir.ends_with('/'):
#		printerr("Close %s with slash: %s/" % [file_dir, file_dir])
#		file_dir += '/'

	if !file_name.is_valid_filename():
		printerr("invalid_filename "+file_name + 'characters that arent allowed in file names')
		print_debug("invalid_filename "+file_name + 'characters that arent allowed in file names')
		return ERR_CANT_CREATE
	
	var config = ConfigFile.new()
	
	for key in settings:
		 config.set_value('Settings', key, settings[key])
	
	var dir: = Directory.new()
	if not dir.dir_exists(file_dir):
		dir.make_dir_recursive(file_dir)
	var err = config.save(file_dir.plus_file(file_name)+".ini")
	if err == OK:
		return err
	else:
		printerr(err)
		print_debug(err)
		return err

func load_settings_config(file_dir: String, file_name: String):
	var config = ConfigFile.new()
	var err = config.load(file_dir.plus_file(file_name)+".ini")
	if err == OK:
		var settings = {}
#		settings[i['name']] = get(i['name'])
		for section in config.get_sections():
			for key in config.get_section_keys(section):
				settings[key] = config.get_value(section, key)
		Global.SETTINGS.set_settings(settings)
	else:
		printerr(err)
		print_debug(err)


# JSON VARIATION - Old version
func save_settings_JSON()->void:
	var dir: = Directory.new()
	if not dir.dir_exists(CONFIG_DIR):
		dir.make_dir_recursive(CONFIG_DIR)
	var SettingsSaver:File = File.new()
	SettingsSaver.open(CONFIG_DIR + CONFIG_FILE_NAME + ".save", File.WRITE)
	var save_data:Dictionary = get_save_data_JSON()
	SettingsSaver.store_line(to_json(save_data))
	SettingsSaver.close()
	print('Save_settings_JSON')

func load_settings_JSON()->bool:
	if Settings.HTML5: 										#need to confirm but for now means that HTML5 won't use the saving
		return	false
	#Json to Dictionary
	var SettingsLoader:File = File.new()
	if !SettingsLoader.file_exists(CONFIG_DIR + CONFIG_FILE_NAME + CONFIG_EXTENSION):
		return  false										#We don't have a save to load
	SettingsLoader.open(CONFIG_DIR + CONFIG_FILE_NAME + CONFIG_EXTENSION, File.READ)
	var save_data = parse_json(SettingsLoader.get_line())
	SettingsLoader.close()
	
	set_save_data_JSON(save_data)								#Dictionary to Settings
	return true

func get_save_data_JSON()->Dictionary:
	var savedata: = {
		inputs = SettingsControls.get_input_data(),
		}
	return savedata

func set_save_data_JSON(save_data:Dictionary)->void:
	SettingsControls.set_input_data(save_data.inputs)







extends EditorPlugin

const autoload_order: = [
	'SettingsAudio',
	'SettingsControls',
	'SettingsLanguage',
	'SettingsResolution',
	'SettingsSaveLoad',
	'Settings',
	'Options',
	'Game',
	'ScreenFade',
	'PauseMenu',
	'Hud',
	'MenuEvent',
	'Music',
	'SfxManager',
	'HtmlFocus'
]

const autoload_list: = {
	'HtmlFocus'				: 'res://addons/Autoload/HtmlFocus.tscn',
	'Game'					: 'res://addons/Autoload/Game.gd',
	'ScreenFade'			: 'res://addons/Autoload/ScreenFade.tscn',
	'Hud'					: 'res://addons/Autoload/Hud.tscn',
	'PauseMenu'				: 'res://addons/Autoload/PauseMenu.tscn',
	'MenuEvent'				: 'res://addons/Autoload/MenuEvent.gd',
	'Music'					: 'res://addons/Autoload/Music.tscn',
	'SfxManager'			: 'res://addons/Autoload/SfxManager.gd',
	'Options'				: 'res://addons/Autoload/Options.tscn',
	'Settings'				: 'res://addons/Autoload/Settings.gd',
	'SettingsAudio'			: 'res://addons/Autoload/SettingsAudio.gd',
	'SettingsControls'		: 'res://addons/Autoload/SettingsControls.gd',
	'SettingsLanguage'		: 'res://addons/Autoload/SettingsLanguage.gd',
	'SettingsResolution'	: 'res://addons/Autoload/SettingsResolution.gd',
	'SettingsSaveLoad'		: 'res://addons/Autoload/SettingsSaveLoad.gd'}

func _init():
	for key in autoload_order:
		add_autoload_singleton(key, autoload_list[key])
	print('\n\n\n IMPORTANT: Please set audio bus layout to - "res://addons/GameTemplate/Assets/Audio_bus_layout.tres" \n\n')

func _enter_tree():
	for key in autoload_order:
		add_autoload_singleton(key, autoload_list[key])
	print('\n\n\n IMPORTANT: Please set audio bus layout to - "res://addons/GameTemplate/Assets/Audio_bus_layout.tres" \n\n')


func _exit_tree():
	var keys: = autoload_list.keys()
	for key in keys:
		remove_autoload_singleton(key)


func has_main_screen():
	return false


func get_plugin_name():
	return "GameTemplate"

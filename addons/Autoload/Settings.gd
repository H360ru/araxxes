#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Modified code of Godot-GameTemplate
# Star original github project: https://github.com/nezvers/Godot-GameTemplate
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extends Node

var HTML5:bool = false

func _ready()->void:				
	if OS.get_name() == "HTML5":
		HTML5 = true
#	SettingsLanguage.add_translations()											#TO-DO need a way to add translations to project through the plugin
#	SettingsResolution.get_resolution()
#	if !SettingsSaveLoad.load_settings():
#		SettingsControls.default_controls()
#		print("default_controls")
#	SettingsAudio.get_volumes()
	#SettingsSaveLoad.save_settings()											#Call this method to trigger Settings saving
	settings_init()

#TO_DO: переместить вызов в менеджер настроек
func settings_init():
	if !SettingsSaveLoad.load_settings():
		SettingsControls.default_controls()
		SettingsSaveLoad.load_settings_default()
		# TODO: добавить вызов диалога
		SettingsSaveLoad.save_settings()
		print("DEFAULT CONTROLS")
		return "default_controls"

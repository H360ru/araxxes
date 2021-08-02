extends Control


func _on_controls():
	get_parent()._to_child_name("Управление")


func _on_default():
#	Global.SETTINGS.load_settings()
# warning-ignore:return_value_discarded
	SettingsSaveLoad.load_settings_default()
	get_parent().update_control()
	pass


func _on_exit():
	if Global.SETTINGS.changed:
		get_parent().wait_popup_for('save_and_back', ['Сохранить', 'Не сохранять'], 0)# ['confirmed'])
	else:
		get_parent()._back()


func _on_CheckBox_toggled(button_pressed):
	Global.MOUSE.toggle_cursor(!button_pressed)


func _on_Default_pressed():
	Global.SETTINGS.load_settings()

extends SpinBox

export(String) var setting

func _enter_tree():
	#print('Type: ', get_class())
	if !setting:
		push_error(name + ': setting is null')
	
	var _class = get_class()
	
	match _class:
		'Range', 'SpinBox', "Slider", "HSlider", "VSlider":
			set_value_from_settings()
			connect('value_changed', self, "_changed")
		_:#'OptionButton', 'Control':
			printerr('Скрипт не предназначен для этого класса')
			print_debug('Скрипт не предназначен для этого класса')
			assert(false, 'Скрипт не предназначен для этого класса')

#func _init():
#
##func _ready():
#	set('pressed', Global.SETTINGS.get(setting))
#	set('value', Global.SETTINGS.get(setting))

func set_value_from_settings():
	set('pressed', Global.SETTINGS.get(setting))
	set('value', Global.SETTINGS.get(setting))

func _changed(value):
	if setting:
		Global.SETTINGS.set_value(setting, value)
		Global.SETTINGS.set_value("changed", true)
		Global.SOUND.play('ui_set')
	else:
		push_error(name + ': setting is null')

func _index_changed(index):
	if setting:
		Global.SETTINGS.set_value('resolution', call('get_item_metadata', index))
	else:
		push_error(name + ': setting is null')

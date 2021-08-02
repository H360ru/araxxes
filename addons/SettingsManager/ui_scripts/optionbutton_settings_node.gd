extends OptionButton

class_name OptionButtonSetting

export(String) var setting

func _ready():#_enter_tree():
	#print('Type: ', get_class())
	if !setting:
		push_error(name + ': setting is null')

	var _class = get_class()

	match _class:
		'OptionButton':
			selected = match_setting()
			connect('item_selected', self, "_index_changed")
			
		_:#'OptionButton', 'Control':
			printerr('Скрипт не предназначен для этого класса')
			print_debug('Скрипт не предназначен для этого класса')
			assert(false, 'Скрипт не предназначен для этого класса')

#func _changed(value):
#	if setting:
#		Global.SETTINGS.set_value(setting, value)
#	else:
#		push_error(name + ': setting is null')

func _index_changed(index):
	if setting:
		Global.SETTINGS.set_value(setting, call('get_item_metadata', index))
		Global.SETTINGS.set_value("changed", true)
		Global.SOUND.play('ui_set')
	else:
		push_error(name + ': setting is null')
		
#func _ready():
##	add_icon_item(load('res://Assets/UI/unitedkingdom.png'), 'English')
##	set_item_metadata(get_item_count()-1, 'en')
##	add_icon_item(load('res://Assets/UI/russia.png'), 'Русский')
##	set_item_metadata(get_item_count()-1, 'ru')
#
#	selected = match_setting()

func match_setting():
	var check = Global.SETTINGS.get(setting)
	for index in range(get_item_count()):
		var meta = get_item_metadata(index)
		if meta == check:
			return index
	printerr(name+' Ошибка настроек '+setting)
	# Возможные ошибки:
	# Добавление айтемов уже после проверки
	# Айтем просто не добавлен
	print_debug(name+' Ошибка настроек '+setting)
	return FAILED

extends OptionButtonSetting

func _enter_tree():
	add_icon_item(load('res://Assets/UI/unitedkingdom.png'), 'English')
	set_item_metadata(get_item_count()-1, 'en')
	add_icon_item(load('res://Assets/UI/russia.png'), 'Русский')
	set_item_metadata(get_item_count()-1, 'ru')

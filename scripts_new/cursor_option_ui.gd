extends OptionButtonSetting


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	#print(name, ' enter_tree')
	add_icon_item(load('res://Assets/cursor.png'), 'Cursor')
	set_item_metadata(get_item_count()-1, 'res://addons/MouseManager/cursor_node/Cursor2.tscn')
	add_icon_item(load('res://Assets/cursor_45.png'), 'Cursor 2')
	set_item_metadata(get_item_count()-1, 'res://addons/MouseManager/cursor_node/Cursor.tscn')
	add_icon_item(load('res://Assets/cursor_grey.png'), 'Cursor 3')
	set_item_metadata(get_item_count()-1, 'res://addons/MouseManager/cursor_node/Cursor3.tscn')
# warning-ignore:return_value_discarded
	connect("item_selected", self, '_on_select')


func _on_select(index):
	Global.SETTINGS.set_value('cursor', get_item_metadata(index))

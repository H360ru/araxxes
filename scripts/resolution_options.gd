extends OptionButtonSetting


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	add_item('1920x1080', 1)
	set_item_metadata(get_item_count()-1, Vector2(1920, 1080))
	add_item('1440x900', 2)
	set_item_metadata(get_item_count()-1, Vector2(1440, 900))
	add_item('1024x600', 3)
	set_item_metadata(get_item_count()-1, Vector2(1024, 600))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_ResolutionsOptions_item_selected(index):
#	Global.SETTINGS.set_value('resolution', get_item_metadata(index))
##	print(get_item_metadata(index))

extends "res://addons/SettingsManager/ui_scripts/spinbox_settings_node.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	get_line_edit().add_stylebox_override('normal', StyleBoxEmpty.new())

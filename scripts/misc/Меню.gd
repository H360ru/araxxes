#extends Node
#
#func _ready():
#	call_popup()
#
#func call_popup():
#	var window = load("res://Scenes/ConfirmationDialog.tscn").instance()
#	add_child(window)
##	window.visible = true
#	window.popup_centered()
#	var r = yield(window, "answer")
#	print("Window call: ", r)
##	return r

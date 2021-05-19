extends ConfirmationDialog

signal answer

var check: bool = false
var buffer = []

func _enter_tree():
	get_ok().queue_free()
	get_cancel().text = 'ui_cancel'
	
	connect("confirmed", self, "_on_event", ['confirmed'])
	connect("hide", self, "_on_event", ['hide'])
	
	var not_save = add_button('ui_dont_save')
	not_save.modulate = Color.red
	not_save.connect("button_down", self, "_on_event", ['Не сохранять'])
	not_save.connect("button_down", self, "hide")
#	hide()
	var save = add_button('ui_save')
	save.modulate = Color.greenyellow
	save.connect("button_down", self, "_on_event", ['Сохранить'])
	save.connect("button_down", self, "hide")
#func _ready():
#	get_cancel().grab_focus()
#	print()

func _on_event(value):
	buffer += [value]
	print('buffer add ', value)
	yield(get_tree(),"idle_frame")
	if buffer:
		print(buffer)
		emit_signal("answer", buffer)
		buffer.clear()

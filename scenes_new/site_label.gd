extends Button


func _ready():
# warning-ignore:return_value_discarded
	connect("pressed", self, '_on_click')


func _on_click():
#	if event.is_action_pressed('click'):
# warning-ignore:return_value_discarded
	OS.shell_open("https://example.com")


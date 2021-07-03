extends Button


func _ready():
	connect("pressed", self, '_on_click')


func _on_click():
#	if event.is_action_pressed('click'):
	OS.shell_open("https://example.com")


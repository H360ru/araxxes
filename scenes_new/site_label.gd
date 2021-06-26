extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("gui_input", self, '_on_click')


func _on_click(event):
	if event.is_action_pressed('click'):
		OS.shell_open("https://example.com")

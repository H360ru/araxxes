extends TabContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("tab_changed", self, '_on_pre_popup_pressed')
#	set_popup(Button.new())


func _on_pre_popup_pressed(value):
	Global.SOUND.play()

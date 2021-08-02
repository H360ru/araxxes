extends TextureRect

func _ready():
# warning-ignore:return_value_discarded
	connect("mouse_entered", self, "_entered")
# warning-ignore:return_value_discarded
	connect("mouse_exited", self, "_exited")

func _entered():
#	if !Kostil.SOUND.is_playing('beep4'):
#		Kostil.SOUND.play_bgm('beep4')
	self_modulate = Color(1.1,1.1,1.1)#1#modulate.a + 0.2

func _exited():
	self_modulate = Color(1,1,1)#0.2#modulate.a - 0.2

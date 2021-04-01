#Класс для кнопочного управления 

class_name Joystick
extends Base

const KEY_LEFT=1
const KEY_UP=2
const KEY_RIGHT=3
const KEY_DOWN=4


signal onJoystickKey(key,down)


var sett:Setting;

#============

func input(event):
	if event is InputEventKey:
		
		if event.scancode==sett.key_left:
			emit_signal("onJoystickKey",KEY_LEFT,event.pressed)
		if event.scancode==sett.key_up:
			emit_signal("onJoystickKey",KEY_UP,event.pressed)
		
		if event.scancode==sett.key_right:
			emit_signal("onJoystickKey",KEY_RIGHT,event.pressed)
		if event.scancode==sett.key_down:
			emit_signal("onJoystickKey",KEY_DOWN,event.pressed)	
			
	pass



func _init(game).(game):
	
	sett=game.setting
	
	pass


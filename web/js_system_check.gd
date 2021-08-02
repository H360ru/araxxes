extends Node
var _max_touch_points

func _init():
	#print('JavaScriptUtils INIT')
	_max_touch_points = JavaScript.eval('navigator.maxTouchPoints;')#JavaScript.eval('String(navigator.platform);')
	pass







func is_touch_screen():
	#HACK Win10 выдает на нетачскринах почему-то 256
	if _max_touch_points > 0 && _max_touch_points != 256:
		return true
	else:
		return false

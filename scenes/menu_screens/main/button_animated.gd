extends Button

var base_size = rect_size

func _enter_tree():
# warning-ignore:return_value_discarded
	connect("focus_entered", self, "_on__focus_entered")
	connect("focus_exited", self, "_on__focus_exited")
	
	connect("mouse_entered", self, "_on__mouse_entered")
	connect("mouse_exited", self, "_on__mouse_exited")

func _on__focus_entered():
#	rect_size.x += 25
	_anim(self)
	Global.SOUND.play()

func _on__focus_exited():
#	if !has_focus():
#	rect_size.x -= 25
	_anim(self, true)

func _on__mouse_entered():
	grab_focus()

func _on__mouse_exited():
	release_focus()
#	pass

func _check_mouse(i: bool):
	if get_local_mouse_position() < rect_size:
		_on__mouse_entered()

func _anim(node: Control, reverse = false):
	#TO_DO: смещение стартовой при повторных вызовах во время исполнения
#	node.visible = true
	var duration = 0.2
	var direction = 25
	if reverse:
		Global.TWEEN.interpolate_property(node, "rect_min_size:x",
		node.rect_min_size.x, base_size.x, duration,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		
#		Global.TWEEN.interpolate_property(node, "rect_scale",
#		node.rect_scale, Vector2.ONE, duration,
#		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		
		Global.TWEEN.interpolate_property(node, "rect_min_size:y",
		node.rect_min_size.y, base_size.y, duration,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	else:
		Global.TWEEN.interpolate_property(node, "rect_min_size:x",
		node.rect_min_size.x, base_size.x + direction, duration,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#		Global.TWEEN.interpolate_property(node, "rect_min_size:x",
#		node.rect_min_size.x, base_size.x * 1.7, duration,
#		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		
		
#		Global.TWEEN.interpolate_property(node, "rect_scale",
#		node.rect_scale, Vector2.ONE * 1.1, duration,
#		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		
		Global.TWEEN.interpolate_property(node, "rect_min_size:y",
		node.rect_min_size.y, base_size.y * 1.7, duration,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
#	for control_node in get_parent().get_children():
#		if control_node != self:
#			Global.TWEEN.interpolate_method(control_node, '_check_mouse', true, true, duration)
	
	Global.TWEEN.start()

#extends Node
#
#class_name MenuTransition, "res://Assets/AcceptDialog.svg"
#
#export(PackedScene) var control_node
#export(bool) var visible = false
#export(bool) var keep_in_memory = false
#var ui_origin_node: Control
#var ui_parent
#var ui_screen_visible: bool setget set_visible
#
#func set_visible(value):
#	if value:
#		load_control()
#	else:
#		unload_control()
#	if ui_origin_node:
#		ui_origin_node.visible = value
#
#
#
#func _ready():
#	group_children()
#
#	if visible:
#		self.ui_screen_visible = true
#	if keep_in_memory:
#		load_control()
##	if control_node:
##		ui_origin_node = control_node.instance()
##		if !visible:
##			ui_origin_node.visible = false
##		add_child(ui_origin_node)
#
#
#func _on_control_visibility_changed():
#	if ui_origin_node.visible and !keep_in_memory:
#		load_control()
#	elif !keep_in_memory:
#		unload_control()
#
#func load_control():
#	if control_node:
#		print(name, " load_control")
#		ui_origin_node = control_node.instance()
#		if !visible:
#			ui_origin_node.visible = false
#		add_child(ui_origin_node)
#
#func unload_control():
#	if ui_origin_node:
#		print(name, " unload_control")
#		ui_origin_node.queue_free()
#
#func print_name():
#	print(name)
#
#func group_children(group = 'ui'):
#	var arr = []
#	for i in get_children():
#		if i.is_in_group(group):
#			arr += [i]
#			i.ui_parent = self
#	return arr
#
#func _back():
##	print(ui_parent.name)
#	print(name, ' _back to')
#	if ui_parent:
#		Global.SOUND.play('ui_deny')
#
#		print(ui_parent.name)
##		visible = false
#		ui_parent.ui_screen_visible = true
##		ui_parent.ui_origin_node.visible = true
##		_anim(ui_parent.ui_origin_node)
#		_transition(ui_origin_node, ui_parent.ui_origin_node)
#		yield(Global.TWEEN,"tween_completed")
#		ui_origin_node.visible = false
#		self.ui_screen_visible = false
#	else:
#		print('Корень меню ', name)
#
#func _to_child_ind(index:int):
#	Global.SOUND.play()
#
#	get_child(index).visible = true
#	get_child(index).ui_screen_visible = true
##	get_child(index).ui_origin_node.visible = true
##	_anim(get_child(index).ui_origin_node)
##	_anim(ui_origin_node, true)
#	_transition(ui_origin_node, get_child(index).ui_origin_node)
#	yield(Global.TWEEN,"tween_completed")
#	ui_origin_node.visible = false
#	self.ui_screen_visible = false
#
#func _to_child_name(name:String):
#	Global.SOUND.play()
#
#	get_node(name).visible = true
#	get_node(name).ui_screen_visible = true
##	get_node(name).ui_origin_node.visible = true
#	_transition(ui_origin_node, get_node(name).ui_origin_node)
#	yield(Global.TWEEN,"tween_completed")
#	ui_origin_node.visible = false
#	self.ui_screen_visible = false
#
#func _go_to(path):
#	pass
#
#func _transition(from: Node, to: Node):
#	_anim(to)
#	_anim(from, true)
##	yield(Global.TWEEN,"tween_completed")
##	to.rect_position = to.pos
#
#static func _anim(node: Control, reverse = false):
#	#TODO: смещение стартовой при повторных вызовах во время исполнения
#	node.visible = true
#	var duration = 0.3
#	var direction = Vector2(1000, 0)
##	var pos = Vector2(0, 0)#node.rect_position
#	if reverse:
#		Global.TWEEN.interpolate_property(node, "rect_position",
#		node.pos, node.pos + direction, duration,
#		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	else:
#		Global.TWEEN.interpolate_property(node, "rect_position",
#		node.pos + direction, node.pos + Vector2(0, 0), duration,
#		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	Global.TWEEN.start()
#
##func _on_visibility_changed():
##	if visible:#is_visible_in_tree():
##		print("Loadin nodes")
##	else:
##		print("unloadin nodes")

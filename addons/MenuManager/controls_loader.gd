extends Node
# TODO: #17 Мой аддон логики меню, который буду распространять фриварным опенсорсом
#  Все таски в этой ветке предполагаются мне (@alex7850),
#  но можете предложить свое участие
class_name MenuTransition, "res://Assets/AcceptDialog.svg"

export(PackedScene) var main_control_node
export(PackedScene) var mob_control_node
var control_node: PackedScene

export(bool) var visible = false setget set_visible
export(bool) var keep_in_memory = false


var ui_origin_node: Control
var ui_parent

func set_visible(value):
	visible = value
	if value:
		load_control()
	else:
		unload_control()
	if ui_origin_node:
		ui_origin_node.visible = value

func _init():
	pass

func _ready():
	get_viewport().connect("size_changed", self, "size_test")
	control_node = main_control_node
	
	group_children()
	
	if keep_in_memory or visible:
		load_control()

func size_test():
	if Global.get_screen_orientation() < 1:#get_viewport().size.x < 400:
		if control_node != mob_control_node and mob_control_node != null:
			change_control(mob_control_node)
	else:
		if control_node != main_control_node and main_control_node != null:
			change_control(main_control_node)

func _on_control_visibility_changed():
	if ui_origin_node.visible and !keep_in_memory:
		load_control()
	elif !keep_in_memory:
		unload_control()

func load_control():
	if control_node:
		print(name, " load_control")
		ui_origin_node = control_node.instance()
		if !visible:
			ui_origin_node.visible = false
		add_child(ui_origin_node)

func unload_control():
	if ui_origin_node != null and is_instance_valid(ui_origin_node):
		print(name, " unload_control")
		ui_origin_node.queue_free()

func change_control(new_control: PackedScene):
	control_node = new_control
	update_control()

func update_control():
	if visible or keep_in_memory:
		unload_control()
		load_control()

func group_children(group = 'ui'):
	var arr = []
	for i in get_children():
		if i.is_in_group(group):
			arr += [i]
			i.ui_parent = self
	return arr

func _back():
	print(name, ' _back to')
	if ui_parent:
		Global.SOUND.play('ui_deny')
		
		print(ui_parent.name)
		ui_parent.visible = true
		_transition(ui_origin_node, ui_parent.ui_origin_node)
		yield(Global.TWEEN,"tween_completed")
		
		
		self.visible = false
	else:
		print('Корень меню ', name)

func _to_child_ind(index:int):
	Global.SOUND.play()
	
	get_child(index).visible = true
	_transition(ui_origin_node, get_child(index).ui_origin_node)
	yield(Global.TWEEN,"tween_completed")
	
	self.visible = false

func _to_child_name(name:String):
	Global.SOUND.play()
	
	get_node(name).visible = true
	_transition(ui_origin_node, get_node(name).ui_origin_node)
	yield(Global.TWEEN,"tween_completed")

	self.visible = false

#TODO: #28 доделать
func go_to(path):
	pass

#TODO #44: 
func _transition(from: Node, to: Node):
	_anim(to)
	_anim(from, true)

static func _anim(node: Control, reverse = false):
	node.visible = true
	var duration = 0.3
	var direction = Vector2(1000, 0)
	if reverse:
		Global.TWEEN.interpolate_property(node, "rect_position",
		Vector2(0, 0), direction, duration,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	else:
		Global.TWEEN.interpolate_property(node, "rect_position",
		direction, Vector2(0, 0), duration,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	Global.TWEEN.start()

#TODO: #29 рефакторить, непонятен интерфейс (не бинды а принимает на вход сигналы)
# добавить возврат результата
func wait_popup_for(call_method: String, signal_binds: Array = [], mode: int = 0):
	var check = yield(wait_popup_answer(), 'completed')
	var bind_check: bool
#	if mode == 0:
	bind_check = false if mode == 0 else true
	for i in signal_binds:
		print('checking ', str(i))
		bind_check = bind_check or check.has(i) if mode == 0\
		else bind_check and check.has(i)
#			if !check.has(i):
#				bind_check = false
##				break
#			else:
#				break
#	else:
#		bind_check = false
#		for i in signal_binds:
#			if check.has(i):
#				bind_check = true
#				break
	
	if bind_check:
#		get_parent().get_parent().get_parent()._back()
		call(call_method, check)

func wait_popup_answer():
	var window = call_popup()
	var r = yield(window, "answer")
	print("Window call: ", r)
	return r

func call_popup() -> WindowDialog:
	var window = load("res://addons/MenuManager/scenes/ConfirmationDialog.tscn").instance()
	add_child(window)
#	window.visible = true
	window.popup_centered()
	return window

func save_and_back(signal_binds: Array = []):
	print('save binds: ', signal_binds)
	if signal_binds.has('Не сохранять'):
#		SettingsSaveLoad.load_settings()
		Settings.settings_init()
		_back()
	else:
		SettingsSaveLoad.save_settings()
		_back()
#	SettingsControls.changed = false # UI UTIL PROPETRY
#	Global.SETTINGS.changed = false # UI UTIL PROPETRY

func print_test(array: Array):
	print(array)

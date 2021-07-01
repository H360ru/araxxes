extends Node

class_name MouseManager
# HACK POOP не воспринимать код серьезно, все под рефакторинг

# переменная "очереди" для хранения ссылки на последнюю исполняемую функцию
# после передачи в yield следующей хранить ее уже не требуется и его можно перезаписать
# после последнего исполнения ссылка сама удалится
var func_queue: GDScriptFunctionState
#var _queue = []

# Для доступа к курсору
var cursor_instance: Node2D

#HACK POOP
var GLES2: bool

var visible: bool = true setget set_visible
func set_visible(value):
	visible = value
	toggle_cursor(value)

#TO_DO: упразнить
func set_cursor_texture(txt:Resource):
	var node = get_node_or_null('Cursor')
	if node:
		node.texture = txt

#провести инициализацию настроек
func _init():
	GLES2 = bool(OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES2)

#TO_DO: переписать интерфейс понятно
func change_cursor(path:String = Global.SETTINGS.cursor):
	if Global.SETTINGS.use_os_cursor:
		return
	var c = Global.find_node('*Cursor*', true, false)
	if c:
		if c.is_queued_for_deletion():
			print("!!!!!!!!!!!!!!tree_exited!!!!!!!!!!!!!!!!!!")
#			yield(c, "tree_exited")
#			yield(get_tree(), "idle_frame")
			if func_queue:
				yield(func_queue, 'completed')
				call_deferred('change_cursor', path)#change_cursor(path)
#			change_cursor(path)
			return
		else:
			c.queue_free()
			yield(c, "tree_exited")
#			print(func_queue)
	var node #= load('res://addons/MouseManager/cursor_node/Cursor3NoShader.tscn')#load(path)
	var _cursor_node_path = 'res://addons/MouseManager/cursor_node/'
	var _no_shader_path = 'no_shader/'
	if GLES2:#if Global.is_html():
		node = load(_cursor_node_path+_no_shader_path+ path.trim_prefix(_cursor_node_path))
	else:
		node = load(path)
	
	if node:
		Global.add_child(node.instance())
	else:
		printerr('Wrong cursor path')
		print_debug('Wrong cursor path')
#	func_queue = null

#Разделить вызов курсора и его отображение (системное или нет)
func toggle_cursor(show:bool):
	if show:
		if Global.SETTINGS.use_os_cursor:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
	#		add_child(load(SETTINGS.cursor).instance())
			#TO_DO: переименовать функции понятно
			change_cursor(Global.SETTINGS.cursor)
	else:
		if Global.SETTINGS.use_os_cursor:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		else:
			delete_cursor_instance()
#		var c = Global.find_node('*Cursor*', true, false)
#		if c:
#			c.queue_free()

#Не использовать для вызова курсора
func create_cursor_instance(path:String = Global.SETTINGS.cursor):
	var node = load(path)
	if node:
		Global.add_child(node.instance())
	else:
		printerr('Wrong cursor path')
		print_debug('Wrong cursor path')

func delete_cursor_instance():
	var c = Global.find_node('*Cursor*', true, false)
	if c:
		c.queue_free()

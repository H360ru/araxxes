extends Sprite

onready var _shader = get_material()#material.shader
var prev_pos: Vector2

func _init(value = 'Cursor init test'):
	print(value)
#	if true:
#		set_script(load("res://Scripts/cursor_no_shader.gd"))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	prev_pos = get_global_mouse_position()
	scale = Vector2(Global.SETTINGS.cursor_size,Global.SETTINGS.cursor_size)
	#HACK: потом сделать инициализацию по нормальному
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES2:
		set_script(load("res://addons/MouseManager/cursor_scripts/cursor_no_shader.gd"))
		return #продумать условия выхода, были баги с выполнением старого скрипта
		#уже после замены новым

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	position = get_global_mouse_position()
#	_shader.set_shader_param("strength", (prev_pos - position).length()/60)
#	_shader.set_shader_param("angle_degrees", rad2deg((prev_pos - position).angle()))
#	prev_pos = position
#	if get_tree().is_connected()
	update()

func update():
	position = get_global_mouse_position()
	_shader.set_shader_param("strength", (prev_pos - position).length()/60)
	_shader.set_shader_param("angle_degrees", rad2deg((prev_pos - position).angle()))
	prev_pos = position

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

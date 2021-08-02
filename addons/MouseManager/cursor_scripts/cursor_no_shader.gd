extends Sprite
#
#onready var _shader = get_material()#material.shader
#var prev_pos: Vector2
#
#func _init(value = 'Cursor init test'):
#	#print(value)
#	if true:
#		set_script()
#
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#	prev_pos = get_global_mouse_position()
	scale = Vector2(Global.SETTINGS.cursor_size,Global.SETTINGS.cursor_size)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position()
#	_shader.set_shader_param("strength", (prev_pos - position).length()/60)
#	_shader.set_shader_param("angle_degrees", rad2deg((prev_pos - position).angle()))
#	prev_pos = position
#
func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

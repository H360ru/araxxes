extends Sprite

# TODO: #25 Класс перемещения юнитов по гриду
#  Предварительная заготовка, вырвиглазная реализация временна
var selected: bool = false setget set_selected
var anim_state: Tweening.Tweener
onready var TILE = get_node('../TileMap')
onready var SOUND = load("G:/Projects/Araxxes/tests/sound_test/SoundManager.gd").new()

func set_selected(value):
	selected = value
	modulate = Color.red if value else Color.white

func _init():
	set_network_master(1, true)

func _ready():
	Global.add_child(SOUND)

signal move_started()
signal move_finished()

func _input(event):#input(event):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click") and selected:
			rpc('go_to', get_global_mouse_position())
			get_tree().multiplayer.send_bytes(var2bytes('packet_test'), 1)
			print(TILE.get_cellv(TILE.world_to_map(get_global_mouse_position())))

remotesync func go_to(_point: Vector2):
	
	Console.write_line("id: " + str(get_tree().get_rpc_sender_id()))
#	Console.write_line("go to point: " + str(_point))
	async_go_to_path(_point)

# puppet func go_to(_point: Vector2):
# Console.write_line("id: " + str(get_tree().get_rpc_sender_id()))
# #	Console.write_line("go to point: " + str(_point))
# async_go_to_path(_point)

# стоит ли внедрять префикс async?
# TO_DO: выделить подметоды
# Разделить визуальное представление с изменением данных
func async_go_to_path(_point: Vector2):
	# TO_DO: в классе tween нет проверки отдельного твининга
	if anim_state and is_instance_valid(anim_state):
#		yield(anim_state, 'finished')
		return
	var path = Path2D.new()
	var curve = Curve2D.new()
#	var tween = Tween.new()
	var duration: float = 1
	
	add_points_arr_curve(curve, [position, _point])
	path.set_curve(curve)
	
	get_parent().add_child(path)
	var follow = PathFollow2D.new()
	path.add_child(follow)
	
	get_parent().remove_child(self)
	position = Vector2.ZERO
	follow.add_child(self)
	
#	Global.TWEEN.interpolate_property(follow, "unit_offset",
#		0, 1, duration,
#		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	Global.TWEEN.start()
	var _tw = Tweening.tween_to(follow, "unit_offset", 1, duration)
	anim_state = _tw
	
	# Global.SOUND.async_play_until_signal('vehicle', self, 'move_finished')
	SOUND.async_play_until_signal('vehicle', self,'move_finished')
	yield(_tw, 'finished')
	
	var pos = global_position
	
	follow.remove_child(self)
	path.get_parent().add_child(self)
	position = pos
	
	follow.queue_free()
	path.queue_free()
	
	emit_signal("move_finished")

func add_points_arr_curve(_curve:Curve2D, _arr: Array):
	for i in _arr:
		_curve.add_point(i)
	

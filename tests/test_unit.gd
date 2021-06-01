extends Sprite

# @todo #9 Класс перемещения юнитов по гриду
#  Предварительная заготовка, вырвиглазная реализация временна

signal move_started()
signal move_finished()

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			rpc('go_to', get_global_mouse_position())

remotesync func go_to(_point: Vector2):
	Console.write_line("go to point: " + str(_point))
	async_go_to_path(_point)

# стоит ли внедрять префикс async?
# TO_DO: выделить подметоды
func async_go_to_path(_point: Vector2):
	# TO_DO: в классе tween нет проверки отдельного твининга
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
	
	Global.TWEEN.interpolate_property(follow, "unit_offset",
		0, 1, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	Global.TWEEN.start()
	
	#HACK: ну вы поняли лол
	while true:
		var yield_check = yield(Global.TWEEN, 'tween_completed')
		if yield_check[0] == follow:
			break
	
	var pos = global_position
	
	follow.remove_child(self)
	path.get_parent().add_child(self)
	position = pos
	
	follow.queue_free()
	path.queue_free()

func add_points_arr_curve(_curve:Curve2D, _arr: Array):
	for i in _arr:
		_curve.add_point(i)
	

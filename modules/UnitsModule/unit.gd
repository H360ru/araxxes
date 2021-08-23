extends Node2D

class_name Unit

export(Resource) var weapon
export(int, 1, 10_000) var max_health
export(int, 1, 10_000) var max_action_points

# сигналы окончания анимаций
signal move_finished
signal attacked
# сигналы о нулевых значениях
signal out_of_health
signal exhausted
# сигналы о уменьшении значений
signal damaged(by)
signal acted(by)

var map_position:Vector2

var health:int
var action_points:int

var active:bool = true

func _ready():
	health = max_health
	restore_points()

func restore_points():
	action_points = max_action_points

func is_active():
	return active

func disable():
	active = false
	
func enable():
	active = true

func move_along_global_path(path:PoolVector2Array):
	emit_signal("move_finished") # по дефолту никаких анимаций

func attack_to_global(global_pos:Vector2):
	emit_signal("attacked") # по дефолту никаких анимаций

func damage(by:int):
	health -= by
	emit_signal("damaged", by)
	if health <= 0:
		health = 0
		emit_signal("out_of_health")


func can_act(action:int):
	return action_points >= action
	
func can_shoot():
	return can_act(weapon.shoot_action_cost)
	
func act(by:int):
	action_points -= by
	emit_signal("acted", by)
	if action_points <= 0:
		action_points = 0
		emit_signal("exhausted")

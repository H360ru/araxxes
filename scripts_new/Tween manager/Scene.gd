extends Node2D

#const i = rand_range(1,5)

func _ready():
	var t = Tweening.sequence(self)\
	.append(Tweening.tween_to($icon, "position", Vector2(400, 400), 2).set_transition(Tween.TRANS_CUBIC))\
	.append(Tweening.tween_to($icon, "position", Vector2(800, 200), 2))
	yield(t, 'completed')
	#print('Test move')
#	t = null
	yield(get_tree(), "idle_frame")
	
	var color = Tweening.tween_to($icon, "modulate", Color.red, 1)
	Tweening.tween_to($icon, "rotation_degrees", 360, 1.5).set_delay(0.2)
##	t.append(color)
	yield(color, 'finished')
	#print('Test color')
	
#	t.append(Tweening.tween_to($icon, "position", Vector2(400, 400), 2).set_transition(Tween.TRANS_CUBIC))\
#	.append(Tweening.tween_to($icon, "position", Vector2(200, 200), 2))
	
#	t.append(Tweening.tween_to($icon, "rotation_degrees", 360, 1.5).set_delay(1))
#	yield(t, 'completed')
#	#print('Test sequence')

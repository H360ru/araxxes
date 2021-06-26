# Изначальный автор https://github.com/KoBeWi
# Изначальный код взят из https://github.com/godotengine/godot/issues/26529#issuecomment-469048886
class_name Tweening
extends Object

static func tween_to(node, property, to, time):
	var tree = node.get_tree()
	
	if !tree.has_meta("tweeners"):
		tree.set_meta("tweeners", [])
	
	var tweener = Tweener.new()
	tweener.node = node
	tweener.property = property
	tweener.to = to
	tweener.time = time
	tweener.trans = Tween.TRANS_LINEAR
	tweener.easing = Tween.EASE_IN_OUT
	tweener.delay = 0
	
	tree.get_meta("tweeners").append(tweener)
	tree.connect("idle_frame", tweener, "start")
	return tweener

static func sequence(object):
	return Sequence.new(object.get_tree())

class Tweener:
	extends Object
	var node
	var property
	var from
	var to
	var time
	var trans
	var easing
	var delay
	
	var tween
	var started = false
	var in_sequence = false
	
	signal finished
	
	func start(from_sequence = false):
		if !started and in_sequence == from_sequence:
			started = true
			
			tween = Tween.new()
			tween.interpolate_property(node, property, node.get(property), to, time, trans, easing, delay)
			node.get_tree().get_root().add_child(tween)
			tween.connect("tween_completed", self, "end")
			tween.start()
	
	func set_ease(new_ease):
		if started:
			printerr("Error: Trying to set ease after starting")
		
		easing = new_ease
		return self
	
	func set_transition(new_trans):
		if started:
			printerr("Error: Trying to set transition after starting")
		
		trans = new_trans
		return self
	
	func set_delay(new_delay):
		if started:
			printerr("Error: Trying to set delay after starting")
		
		delay = new_delay
		return self
	
	func in_sequence():
		in_sequence = true
	
	func end(whatever, whatever2):
		emit_signal("finished")
		tween.queue_free()
		node.get_tree().get_meta("tweeners").erase(self)
		call_deferred('free')

class Sequence:
	extends Object
	var tweeners = []
	var tree
	
	signal completed
	
	func _init(_tree):
		tree = _tree
		
		if !tree.has_meta("tweeners"):
			tree.set_meta("tweeners", [])
		
		tree.get_meta("tweeners").append(self)
		tree.connect("idle_frame", self, "start_next")
#		start_next()
	
	func append(tweener):
		tweeners.append(tweener)
		tweener.in_sequence()
		tweener.connect("finished", self, "prepare_next")
		return self
	
	func prepare_next():
		tweeners.pop_front()
		
		if !tweeners.empty():
			start_next()
		else:
			emit_signal("completed")
			tree.get_meta("tweeners").erase(self)
			call_deferred('free')
	
	func start_next():
		tweeners[0].start(true)
#		Возможны баги, тогда используй
#		if !tweeners.empty():
#			tweeners[0].start(true)

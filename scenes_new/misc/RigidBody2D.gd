extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	mode = 1
	connect("mouse_exited", self, '_mode')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mode == 0 and is_network_master():
		
#		rset_unreliable('global_transform', global_transform)
		rpc_unreliable('transform_update', global_transform)

remote func transform_update(_transform):
	global_transform = _transform

func _mode():
	rset('mode', 0)
	mode = 0
	print('ahdghagag mode')

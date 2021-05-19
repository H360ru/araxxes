extends GridContainer


# Declare member variables here. Examples:
# var a = 2
var min_size = 160


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("resized", self, "_on_resized")

func _on_resized():
	if (rect_size.x / columns) < min_size:
		if columns > 1:
			columns = columns - 1
	elif (rect_size.x / (columns+1)) > min_size:
		if get_child_count() >= (columns+1):
			columns = columns + 1

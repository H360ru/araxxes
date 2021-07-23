extends Sprite

# The nodepath to the color mask viewport.
export (NodePath) var path_to_viewport;

func _ready():
	# Simply set the mask_texture shader parameter to the Viewport texture.
	material.set_shader_param("mask_texture", get_node(path_to_viewport).get_texture());
	pass

tool
extends Node2D

class_name IsoSprite

# Текстуры
export(Texture) var texture setget set_texture
export(Texture) var normal_map setget set_normal_map

# Параметры
export(int, 1, 720) var directions = 1 setget set_directions
export(int, 1, 1024) var frames = 1setget set_frames

# Инициализация параметров
export(int) var direction = 0 setget set_direction
export(int) var frame = 0 setget set_frame

# Параметры рисования
export(bool) var centered setget set_centered
export(Vector2) var offset setget set_offset


func _draw():
	if texture != null:
		var sprite_size_x = texture.get_width()/directions
		var sprite_size_y = texture.get_height()/frames
		
		var draw_point = offset - (Vector2(sprite_size_x, sprite_size_y)/2 
				if centered else Vector2())
		
		var sprite_rect = Rect2(
				draw_point.x, draw_point.y,
				sprite_size_x, sprite_size_y
		)
		
		var texture_region = Rect2(
				sprite_size_x*direction, sprite_size_y*frame,
				sprite_size_x, sprite_size_y
		)
		
		draw_texture_rect_region(texture, sprite_rect, texture_region, Color.white, false, normal_map)
	

func set_texture(txtr):
	texture = txtr
	update()
	
func set_normal_map(np):
	normal_map = np
	update()
	
func set_directions(dirs):
	directions = dirs
	set_direction(min(directions-1, direction))
	
func set_frames(frs):
	frames = frs
	set_frame(min(frames-1, frame))
	
func set_direction(dir):
	if dir < 0:
		direction = directions-abs(dir)%directions if directions > 1 else 0
	else:
		direction = dir%directions
		
	if Engine.editor_hint:
		property_list_changed_notify()
		
	update()
	
func set_frame(fr):
	if fr < 0:
		frame = frames-abs(fr)%frames if frames > 1 else 0
	else:
		frame = fr%frames
		
	if Engine.editor_hint:
		property_list_changed_notify()
		
	update()
	
func set_centered(centr):
	centered = centr
	update()
	
func set_offset(ofst):
	offset = ofst
	update()


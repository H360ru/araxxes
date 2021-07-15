tool
extends Node2D

class_name IsoSprite

# Текстуры
export(Texture) var texture setget set_texture
export(Texture) var normal_map setget set_normal_map

# Параметры
export(int, 1, 720) var directions = 1 setget set_directions
export(int, 1, 1024) var frames = 1 setget set_frames
export(bool) var counter_clock_wise = false
export(int, 0, 360) var zero_direction_angle = 0

# Инициализация параметров
export(int) var direction = 0 setget set_direction
export(int) var frame = 0 setget set_frame

# Параметры рисования
export(bool) var centered setget set_centered
export(Vector2) var offset setget set_offset


func _draw():
	if texture != null:
		var sprite_size_x:int = texture.get_width()/directions
		var sprite_size_y:int = texture.get_height()/frames
		
		var draw_point:Vector2 = offset
		if centered:
			draw_point.x -= sprite_size_x/2
			draw_point.y -= sprite_size_y/2
		
		var sprite_rect:Rect2 = Rect2(
				draw_point.x, draw_point.y,
				sprite_size_x, sprite_size_y
		)
		
		var texture_region:Rect2 = Rect2(
				sprite_size_x*direction, sprite_size_y*frame,
				sprite_size_x, sprite_size_y
		)
		
		draw_texture_rect_region(texture, sprite_rect, texture_region, Color.white, false, normal_map)
	

################################################################################
# Public методы ----------------------------------------------------------------
################################################################################

func direct_by_rad(angle:float) -> void:
	angle += deg2rad(zero_direction_angle)
	# Изометрический угол не равен экранному, необходимо преобразовать
	angle = _calc_iso_angle(angle)
	if counter_clock_wise:
		angle = 2*PI - angle
	# Какая часть от всей окружности
	var dir:int = int(round(angle/(2*PI) * directions))
	
	set_direction(dir)

func direct_by_deg(angle:int) -> void:
	direct_by_rad(deg2rad(angle))
	
	
func get_direction_angle_rad(dir:int) -> float:
	dir = _loop_int(dir, directions) # Получаем валидное направление
	# Какая часть окружности приходится на одно направление
	var dir_angle = 2*PI/directions 
	# По часовой отнимаем, против прибавляем
	var angle = dir_angle*dir if counter_clock_wise else -dir_angle*dir
	angle += deg2rad(zero_direction_angle)
	angle = _calc_iso_angle(angle) # Нужно учесть изометрию
	
	return angle
	
func get_direction_angle_deg(dir:int) -> float:
	return rad2deg(get_direction_angle_rad(dir))
	
	
func get_looking_angle_rad() -> float:
	return get_direction_angle_rad(direction)
	
func get_looking_angle_deg() -> float:
	return rad2deg(get_looking_angle_rad())
	
	
func next_direction(loop=true) -> void:
	if loop or direction < directions-1:
		set_direction(direction+1)
	
	
func prev_direction(loop=true) -> void:
	if loop or direction > 0:
		set_direction(direction-1)
	
	
func next_frame(loop=true) -> void:
	if loop or frame < frames-1:
		set_frame(frame+1)
	
	
func prev_frame(loop=true) -> void:
	if loop or frame > 0:
		set_frame(frame-1)

################################################################################
# Сеттеры ----------------------------------------------------------------------
################################################################################


func set_texture(txtr:Texture):
	texture = txtr
	update()
	
func set_normal_map(np:Texture):
	normal_map = np
	update()
	
func set_directions(dirs:int):
	directions = dirs
	set_direction(min(directions-1, direction))
	
func set_frames(frs:int):
	frames = frs
	set_frame(min(frames-1, frame))
	
func set_direction(dir:int):
	direction = _loop_int(dir, directions)
	
	if Engine.editor_hint:
		property_list_changed_notify()
		
	update()
	
func set_frame(fr:int):
	frame = _loop_int(fr, frames)
		
	if Engine.editor_hint:
		property_list_changed_notify()
		
	update()
	
func set_centered(centr:bool):
	centered = centr
	update()
	
func set_offset(ofst:Vector2):
	offset = ofst
	update()

################################################################################
# Локальные методы -------------------------------------------------------------
################################################################################

func _loop_int(value:int, value_border:int):
	if value < 0:
		value = value_border+value%value_border if value_border > 1 else 0
	else:
		value = value%value_border
		
	return value
	
func _calc_iso_angle(phi):
	return Vector2(cos(phi), sin(phi)/2).angle()
	


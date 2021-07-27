extends TileMap

class_name NavigationGrid

# Немного терминологии
# tile - координаты на карте, в которых есть тайл с валидным индексом
# cell - координаты на карте
# pixel - мировые координаты 

signal tilemap_tile_changed(cell, new_tile_id)
signal new_cell_flag(cell, new_flag)
signal cell_flag_removed(cell, removed_flag)

export var obstacles_ids:PoolIntArray = PoolIntArray()

var navigator:AStar2D
var _navigator_used_rect:Rect2 # Размер тайлмапа при последнем парсинге карты

var _tiles_flags = Dictionary() # Координате cell соответствуют ее флаги

################################################################################
# Переопределнные методы -------------------------------------------------------
################################################################################


func _ready():
	navigator = AStar2D.new()
	_navigator_used_rect = Rect2()
	
	build_navigator()


func set_cellv(cell:Vector2, tile_id:int, flip_x:bool=false, flip_y:bool=false, transpose:bool=false) -> void:
	var last_tile_id:int = get_cellv(cell) # Старый тайл этой ячейки
	if tile_id == last_tile_id: # Если старый и новый совпадают то нам все равно
		return
	
	.set_cellv(cell, tile_id, flip_x, flip_y, transpose) # Меняем тайл у самого TileMap
	emit_signal("tilemap_tile_changed", cell, tile_id)
	
	if tile_id == INVALID_CELL: # Если хотим убрать тайл
		# Проверять на вхождение в карту нет необходимсотиб потому что 
		# за картой индекс всегда -1 поэтому tile_id подпадает под первую проверку
		var id:int = _calc_cell_id_vec(cell)
		if navigator.has_point(id): # Если тут была точка навигации избавляемся и от нее
			navigator.remove_point(id)
		return
		
	# Если новая ячейка за пределами текщей карты то 
	# старые индексы не подходят, обрабатываем отдельно
	if not _is_cell_in_map_rect_vec(cell): 
		# Если мы вне карты хотим поставить препятствие,
		# то на навигаторе это никак не отразится поэтому пофиг
		if not tile_id in obstacles_ids:
			build_navigator()
		return
		
	var neigh_id:int
	var cell_id:int = _calc_cell_id_vec(cell) # Индекс этой ячейки
	
	if not tile_id in obstacles_ids: # Если мы не поставили препятствие
		if not navigator.has_point(cell_id):
			navigator.add_point(cell_id, get_cell_center_local(cell))
			
		for neigh in get_cell_neighbors(cell): # Перебираем соседей и соединяем с существующими
			if _is_cell_in_map_rect_vec(neigh): # Если сосед вне карты индекс посчитается неправильно
				neigh_id = _calc_cell_id_vec(neigh)
				
				if navigator.has_point(neigh_id):
					navigator.connect_points(cell_id, neigh_id)
	else: # Ставим препядствие, а значит удаляем точку навигации
		if navigator.has_point(cell_id):
			navigator.remove_point(cell_id)


func set_cell(x, y, tile_id, flip_x:bool=false, flip_y:bool=false, transpose:bool=false, autotile_coord:Vector2=Vector2()) -> void:
	set_cellv(Vector2(x, y), tile_id, flip_x, flip_y, transpose)


func clear() -> void:
	.clear()
	reset_navigator()


################################################################################
# Public методы ----------------------------------------------------------------
################################################################################

func reset_navigator() -> void:
	navigator.clear()

func build_navigator() -> void:
	# Идея парсера отсюда --> https://github.com/progsource/ps_tileastar2d/blob/main/ps_TileAStar2D_TileMapConnector.gd
	_navigator_used_rect = get_used_rect()
	
	reset_navigator()
	
	var id:int # Переменная, чтобы постоянно не создавать новую
	
	# Проходим по всей карте и ставим точки в навигатор на проходимых тайлах
	for x in range(_navigator_used_rect.position.x, _navigator_used_rect.position.x+_navigator_used_rect.size.x):
		for y in range(_navigator_used_rect.position.y, _navigator_used_rect.position.y+_navigator_used_rect.size.y):
			id = get_cell(x, y)
			if id != INVALID_CELL and not id in obstacles_ids:
				navigator.add_point(_calc_cell_id(x, y), get_cell_center_local(Vector2(x, y)))
	
	# Повторный проход, соединяем соседей
	for x in range(_navigator_used_rect.position.x, _navigator_used_rect.position.x+_navigator_used_rect.size.x):
		for y in range(_navigator_used_rect.position.y, _navigator_used_rect.position.y+_navigator_used_rect.size.y):
			id = get_cell(x, y)
			if id == INVALID_CELL or id in obstacles_ids:
				continue
			# Функция _get_three_left_top_neighbors возвращает два левых и 
			# верхнего соседей. Это нужно для избежания повторных соединений, 
			# ведь соединяем мы в таком случае только с одной стороны
			for i in _get_three_left_top_neighbors(x, y):
				id = get_cellv(i)
				if id != INVALID_CELL and not id in obstacles_ids:
					navigator.connect_points(_calc_cell_id(x, y), _calc_cell_id(i.x, i.y))

	
func find_pixel_path(cell1:Vector2, cell2:Vector2) -> PoolVector2Array:
	# Если ячейки вне тайлмапа то нет смысла их проверять
	if not _is_cell_in_map_rect_vec(cell1) or not _is_cell_in_map_rect_vec(cell2):
		return PoolVector2Array()
	
	var idx1:int = _calc_cell_id_vec(cell1)
	var idx2:int = _calc_cell_id_vec(cell2)
	
	if navigator.has_point(idx1) and navigator.has_point(idx2):
		return navigator.get_point_path(idx1, idx2)
	else:
		return PoolVector2Array()


func find_map_path(cell1:Vector2, cell2:Vector2) -> PoolVector2Array:
	var path:PoolVector2Array = find_pixel_path(cell1, cell2)
	for i in range(len(path)):
		path[i] = world_to_map(path[i])
	return path


func get_distance_area(cell:Vector2, distance:int) -> PoolVector2Array:
	# Если вне карты то индекс посчитается неправильно
	if not _is_cell_in_map_rect_vec(cell):
		return PoolVector2Array()
	# Если точки нет то нее никуда не пройти
	if not navigator.has_point(_calc_cell_id_vec(cell)):
		return PoolVector2Array()
		
	# Везде работаем с id, а не координатами
	var start:int = _calc_cell_id_vec(cell)
	var queue:Array = [start] # Колхозная очередь из списка
	
	var area:PoolVector2Array = PoolVector2Array()
	
	# Словарь {id : <кол-во узлов от начала до этой точки>}
	var distances:Dictionary = {}
	distances[start] = 0
	
	var current:int # id рассматриваемой точки
	var new_distance:int
	
	# Типичный проход в шрину
	while not queue.empty():
		
		current = queue.pop_front()
		area.append(navigator.get_point_position(current))
		
		for neigh in navigator.get_point_connections(current):
			new_distance = distances[current] + 1
			# Добавляем новую точку только если расстояние до нее не больше чем надо
			if not neigh in distances:
				if new_distance <= distance: 
					distances[neigh] = new_distance
					queue.append(neigh)
			else:
				if new_distance < distances[neigh]:
					distances[neigh] = new_distance
					# Перерассматриваем точку что бы от нее все посчиталось правильно
					queue.append(neigh)
	
	return area


func get_cell_center_local(cell:Vector2) -> Vector2:
	return map_to_world(cell)+cell_size/2
	
	
func get_cell_center_global(cell:Vector2) -> Vector2:
	return to_global(get_cell_center_local(cell))
	

func get_cell_neighbors(cell:Vector2) -> Array:
	match cell_half_offset:
		HALF_OFFSET_Y:
			return _get_cell_neighs_y(cell)
		HALF_OFFSET_NEGATIVE_Y:
			return _get_cell_neighs_neg_y(cell)
		_:
			printerr("No support")
			return []


func add_cell_flag(cell:Vector2, flag:int) -> void:
	assert(flag >= 0) # Не бывает отрицательных флагов
	# Все флаги хранятся в битах числа
	var bit_flag:int = 1<<flag # Равносильно возведению 2 в степень flag
	
	if not cell in _tiles_flags: # Если еще не было то создаем
		_tiles_flags[cell] = bit_flag
	else:
		_tiles_flags[cell] |= bit_flag # Активируем нужный бит
		
	emit_signal("new_cell_flag", cell, flag)


func remove_cell_flag(cell:Vector2, flag:int) -> void:
	assert(flag >= 0) # Не бывает отрицательных флагов
	var bit_flag:int = 1<<flag
	# Убираем только включенный флаг, иначе это затронет другие биты (т.е. флаги)
	if is_cell_has_flag(cell, flag):
		_tiles_flags[cell] -= bit_flag
		emit_signal("cell_flag_removed", cell, flag)


func get_cell_flags(cell:Vector2) -> int:
	# Если ячейки нет в словаре, значит никто не манипулировал ее флагами
	if not cell in _tiles_flags:
		return 0 
	else:
		return _tiles_flags[cell]
	

func is_cell_has_flag(cell:Vector2, flag:int) -> bool:
	var bit_flag:int = 1<<flag
	
	if cell in _tiles_flags:
		return _tiles_flags[cell]&bit_flag > 0
	else: # Если ячейка не была записана, значит флагов нет
		return false
		

func get_cells_with_flag(flag:int) -> PoolVector2Array:
	var bit_flag:int = 1<<flag
	
	var res:PoolVector2Array = PoolVector2Array()
	
	for i in _tiles_flags.keys():
		if _tiles_flags[i]&bit_flag > 0:
			res.append(i)
			
	return res
	
################################################################################
# Local методы -----------------------------------------------------------------
################################################################################

func _get_three_left_top_neighbors(x:int, y:int) -> Array:
	# Возвращает двух левых и верхнего соседей
	# Пока работает только для смещений по Y
	var res:Array
	var parity:int
	if cell_half_offset == HALF_OFFSET_NEGATIVE_Y:
		parity = 1
	elif cell_half_offset == HALF_OFFSET_Y:
		parity = -1
	else:
		printerr("Соседи для такого смещения недоступны")
		return []
		
	var y_offset:int = parity*(1 - 2*(int(abs(x))%2))
	
	res = [
		Vector2(x, y-1),
		Vector2(x-1, y),
		Vector2(x-1, y+y_offset)
	]
	
	return res


func _get_cell_neighs_neg_y(cell:Vector2) -> Array:
	var res:Array
	res = [
		cell + Vector2(1, 0),
		cell + Vector2(-1, 0),
		cell + Vector2(1, 1-2*(int(abs(cell.x))%2)),
		cell + Vector2(-1, 1-2*(int(abs(cell.x))%2)),
		cell + Vector2(0, -1),
		cell + Vector2(0, 1)
	]
	return res


func _get_cell_neighs_y(cell:Vector2) -> Array:
	var res:Array
	res = [
		cell + Vector2(1, 0),
		cell + Vector2(-1, 0),
		cell + Vector2(1, 2*(int(abs(cell.x))%2)-1),
		cell + Vector2(-1, 2*(int(abs(cell.x))%2)-1),
		cell + Vector2(0, -1),
		cell + Vector2(0, 1)
	]
	return res
	
	
func  _is_cell_in_map_rect_vec(cell:Vector2) -> bool:
	# Находится ли клетка внутри тайлмапа
	var is_x:bool = (cell.x >= _navigator_used_rect.position.x and 
		cell.x < _navigator_used_rect.position.x + _navigator_used_rect.size.x)
	var is_y:bool = (cell.y >= _navigator_used_rect.position.y and
		cell.y < _navigator_used_rect.position.y + _navigator_used_rect.size.y)
		
	return is_x and is_y
	
func _is_cell_in_map_rect(x:int, y:int) -> bool:
	return _is_cell_in_map_rect_vec(Vector2(x, y))
	
	
func _calc_cell_id(x:int, y:int) -> int:
	var x_id_component:int = x + abs(_navigator_used_rect.position.x)
	var y_id_component:int = (y + abs(_navigator_used_rect.position.y))*_navigator_used_rect.size.x
	return x_id_component + y_id_component
	
	
func _calc_cell_id_vec(point:Vector2) -> int:
	return _calc_cell_id(int(point.x), int(point.y))
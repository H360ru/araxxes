extends TileMap

class_name HexGrid

export var obstacles_ids = PoolIntArray()

var navigator:AStar2D
var _navigator_used_rect:Rect2 # Размер тайлмапа при последнем парсинге карты

func _ready():
	navigator = AStar2D.new()
	_navigator_used_rect = Rect2()
	
	build_navigator()


func build_navigator():
	# Идея парсера отсюда --> https://github.com/progsource/ps_tileastar2d/blob/main/ps_TileAStar2D_TileMapConnector.gd
	_navigator_used_rect = get_used_rect()
	
	navigator.clear()
	
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

	
func find_path(point1, point2):
	# Если ячейки вне тайлмапа то нет смысла их проверять
	if not _is_cell_in_map_rect(point1) or not _is_cell_in_map_rect(point2):
		return []
	
	var idx1 = _calc_cell_id_vec(point1)
	var idx2 = _calc_cell_id_vec(point2)
	
	if navigator.has_point(idx1) and navigator.has_point(idx2):
		return navigator.get_point_path(idx1, idx2)
	else:
		return []


func get_cell_center_local(cell):
	return map_to_world(cell)+cell_size/2
	
	
func get_cell_center_global(cell):
	return to_global(get_cell_center_local(cell))
	

func get_cell_neighbors(cell):
	match cell_half_offset:
		HALF_OFFSET_Y:
			return _get_cell_neighs_y(cell)
		HALF_OFFSET_NEGATIVE_Y:
			return _get_cell_neighs_neg_y(cell)
		_:
			printerr("No support")
			return []
			


func _get_three_left_top_neighbors(x:int, y:int):
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
		
	var y_offset = parity*(1 - 2*(int(abs(x))%2))
	
	res = [
		Vector2(x, y-1),
		Vector2(x-1, y),
		Vector2(x-1, y+y_offset)
	]
	
	return res


func _get_cell_neighs_neg_y(cell):
	var res
	res = [
		cell + Vector2(1, 0),
		cell + Vector2(-1, 0),
		cell + Vector2(1, 1-2*(int(cell.x)%2)),
		cell + Vector2(-1, 1-2*(int(cell.x)%2)),
		cell + Vector2(0, -1),
		cell + Vector2(0, 1)
	]
	return res


func _get_cell_neighs_y(cell):
	var res
	res = [
		cell + Vector2(1, 0),
		cell + Vector2(-1, 0),
		cell + Vector2(1, 2*(int(cell.x)%2)-1),
		cell + Vector2(-1, 2*(int(cell.x)%2)-1),
		cell + Vector2(0, -1),
		cell + Vector2(0, 1)
	]
	return res
	
	
func  _is_cell_in_map_rect(cell):
	# Находится ли клетка внутри тайлмапа
	var is_x = (cell.x >= _navigator_used_rect.position.x and 
		cell.x < _navigator_used_rect.position.x + _navigator_used_rect.size.x)
	var is_y = (cell.y >= _navigator_used_rect.position.y and
		cell.y < _navigator_used_rect.position.y + _navigator_used_rect.size.y)
		
	return is_x and is_y
	
	
func _calc_cell_id(x:int, y:int):
	var x_id_component = x + abs(_navigator_used_rect.position.x)
	var y_id_component = (y + abs(_navigator_used_rect.position.y))*_navigator_used_rect.size.x
	return x_id_component + y_id_component
	
	
func _calc_cell_id_vec(point:Vector2):
	return _calc_cell_id(int(point.x), int(point.y))

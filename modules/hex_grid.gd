extends TileMap
# TODO: #22 Класс грида, отвечает за связь с тайлмапом
#  низкоуровневую работу с уровнем, создание, удаление клеток
#  (возможно еще перемещение)

class_name HexGrid

export var map_size = Vector2(1024, 1024) # Необходимо для задания id клеткам
export(int, 0, 100) var border = 10 # Допустимое превышение размера карты, в том числе и в отрицательную область

var navigator:AStar2D

func _ready():
	navigator = AStar2D.new()

func build_navigator(obsts_ids:Array=[]): # obsts_ids - массив с индексами тайлов, которые воспринимаются как препядствия
	navigator.clear()
	var start = Vector2()
	# Необходимо начать с валидной ячейки
	var valid_map = false
	for i in get_used_cells():
		if _is_cell_valid(i) and not get_cellv(i) in obsts_ids:
			start = i
			valid_map = true
			break
	# Валидных нет
	if not valid_map:
		printerr("Map must have tiles inside " + str(map_size))
		return
	# Проход карты заливкой
	var queue = [start]
	var cur
	var visited = PoolIntArray()
	navigator.add_point(_calculate_tile_id(start), get_cell_center_local(start))
	while len(queue) != 0:
		cur = queue.pop_front()
		for neigh in get_tile_neighbors(cur, obsts_ids):
			if _is_cell_valid(neigh): # Если сосед валидный
				if not (_calculate_tile_id(neigh) in visited):
					navigator.add_point(_calculate_tile_id(neigh), get_cell_center_local(neigh)) # Его добавляем
					navigator.connect_points(_calculate_tile_id(cur), _calculate_tile_id(neigh)) # И соединяем с текущей клеткой
					queue.append(neigh)
			else:
				printerr("Point " + str(neigh) + " is out of map borders")
		visited.append(_calculate_tile_id(cur))

func find_path(point1, point2):
	var id1 = _calculate_tile_id(point1)
	var id2 = _calculate_tile_id(point2)
	if _is_cell_valid(point1) and _is_cell_valid(point2) and navigator.has_point(id1) and navigator.has_point(id2):
		return navigator.get_point_path(id1, id2)
	else:
		return []

func get_cell_center_local(cell):
	return map_to_world(cell)+cell_size/2
	
func get_cell_center_global(cell):
	return to_global(get_cell_center_local(cell))
	
# tile - клетка с тайлом
func get_tile_neighbors(tile_pos:Vector2, unavailable_ids:Array=[]): # unavailable_ids - неугодные тайлы, которых избегаем
	var res:Array = []
	var cell_id
	for i in get_cell_neighbors(tile_pos):
		cell_id = get_cellv(i)
		if cell_id != INVALID_CELL and not(cell_id in unavailable_ids):
			res.append(i)
	return res
	
# cell - просто координата на карте
func get_cell_neighbors(cell):
	match cell_half_offset:
		HALF_OFFSET_Y:
			return _get_cell_neighs_y(cell)
		HALF_OFFSET_NEGATIVE_Y:
			return _get_cell_neighs_neg_y(cell)
		_:
			printerr("No support")
			return []
			
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

func _is_cell_valid(cell): # Проверяем лежит ли cell внутри карты
	return cell.x > -border and cell.x < map_size.x+border and cell.y > -border and cell.y < map_size.y+border
	
func _calculate_tile_id(cell) -> int: # Получаем id клетки
	return int((cell.x+border)*map_size.x + cell.y+border)
	
func _get_tile_coord_from_id(id:int) -> Vector2:
	var res = Vector2()
	res.x = int(id/map_size.x)-border
	res.y = id%int(map_size.y)-border
	return res
	
# TODO: #36 Продумать связь града с игровыми объектами.
#  Например: Эффект от взрыва может вызывать методы как на тайлы, так и на юнитов

#  Упращенная форма тз в качестве памятки. Предполагает свободную формулировку и обсуждение.
# SIGNAL
# tilemapTileChanged (NOT URGENT) Callback when Tiles on a Tilemap have changed.

# TODO: #37 Создать основные методы
# ASAP METHODS:

#  GetCellCenterLocal	Get the logical center coordinate of a grid cell in local grid space.
#  GetCellCenterWorld	Get the logical center coordinate of a grid cell in world space.

#  GetTileFlags	Gets the TileFlags of the Tile at the given position (id?).
#  GetCellNeighbours Retrieves an array of tiles


# NOT URGENT METHODS:

#  GetTilesShape	Retrieves an array of tiles with the given cell bounds. 
#  ShapeFill	Does a box fill with the given ONE tile on the tile map. Starts from given coordinates and fills the limits from start to end (inclusive).

#  SetTileFlags	Sets the TileFlags ARRAY onto the Tile at the given position.
#  RemoveTileFlags	Removes TileFlags ARRAY from the Tile at the given position.

#  SetTilesShape	Fills bounds with ARRAY of tiles.

# VERY NOT URGENT METHODS:

# FloodFill	Does a flood fill with the given tile to place. on the tile map starting from the given coordinates.

# SetTilesArray	Sets an array of tiles at the given XY coordinates of the corresponding cells in the tile map.

# SwapTile	Swaps all existing tiles of changeTile to newTile and refreshes all the swapped tiles.
# ClearAllTiles	Clears all tiles that are placed in the Tilemap. Вроде уже есть в тайлмап void clear ( )

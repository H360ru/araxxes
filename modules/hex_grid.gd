extends Node

# TODO: #22 Класс грида, отвечает за связь с тайлмапом
#  низкоуровневую работу с уровнем, создание, удаление клеток
#  (возможно еще перемещение)

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


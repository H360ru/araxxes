class_name Route
extends Object

#Маршрут состоит с плиток RouteTile
var tiles:Array=[]

#Плитки, которые били использованы при прокладке маршрута
var arrTiles:Array
#Лимит в массиве arrTiles
var arrTilesLimit=0;


#есть ли передаваемая плитка в поиске маршрута, вернет индекс шага или -1
func containTile(tileCheck:Vector2):
	var i=0
	for tile in arrTiles:
		if tile.x as int==tileCheck.x as int && tile.y as int==tileCheck.y as int:
			
			return tile.step
		i+=1
		if i>=arrTilesLimit:
			break
			
	return -1

#Вернуть маршрут в виде массива координат тайлов, лимит, если -1  то лимит не применяется
#offsetBack - Скольок не доходить до конечной плитки
func getPoints(limit,offsetBack=0):
	if tiles!=null:
		var c=0
		var points=[]
		for tile in tiles:
			if tile!=null:
				points.push_back(Vector2(tile.x,tile.y))
				c+=1
				if (limit!=-1 && c>=limit) || (c>=tiles.size()-offsetBack):
					break
				
		return points;
		
		
#проложить маршрут, если извесно что он построен, и есть конечная и начальная плитка
func build(tileStart:RouteTile,tileEnd:RouteTile):
	if tileStart!=null && tileEnd!=null:
		tiles=[]
		while true:
			tiles.push_front(tileEnd)
			if tileEnd.prev!=null && tileEnd.prev.size()>0:
				tileEnd=tileEnd.prev[0]
				if tileEnd==tileStart:
					break;
			else:
				break
		return tiles
	pass

#Вернуть тайлы спайса
func getSpiceTiles():
	if tiles!=null:
		var _spice_tiles=[]
		for tile in tiles:
			if Kostil.GAME.map.manMap.isTileSpice(tile.x as int,tile.y as int):
				_spice_tiles.push_front(tile)
				
		return _spice_tiles;



class_name ManagerMap
extends Base



#поверхность с плитки
var tileMapGround:TileMap
#Для выделения клеток
var tileMapSelect:TileMap

var mapWidth=50
var mapHeight=25

var cameraGame:CameraGame

#Заблокированные плитеи на которые нельзя стать
var blockedTiles:TileBlocks


#очистить выделение
func clearSelect():
	tileMapSelect.clear()

#Выделить плитки idtile типа tile_select_attack
func setTileSelectRoad(route,idTile,limit):
	if route!=null && route.tiles!=null && route.tiles.size()>0:
		tileMapSelect.clear()
		var i=0;
		while true:
			if i<route.tiles.size():
				var tile=route.tiles[i]
				if tile!=null:
					tileMapSelect.set_cell(tile.x,tile.y,idTile)
				i+=1
				if i>=limit:
					break
			else:
				break
	pass
	


#Выделить плитки idtile типа tile_select_attack
func setTileSelect(route,idTile):
	if route!=null && route.arrTiles!=null:
		tileMapSelect.clear()
		var i=0;
		while true:
			if i<route.arrTiles.size():
				var tile=route.arrTiles[i]
				if tile!=null:
					tileMapSelect.set_cell(tile.x,tile.y,idTile)
				i+=1
				if i>=route.arrTilesLimit || i>=route.arrTiles.size():
					break;
					pass
			else:
				break
	pass

func clearTile(x,y):
	tileMapGround.set_cell(x,y,-1)

#Установить на поверхность плитку песка
func setTileSand(x,y):
	tileMapGround.set_cell(x,y,Tile.tile_sand)

#Вернуть плитку по координатам
func getCooTile(point2d):
	return tileMapGround.world_to_map(point2d)
	
#Вернуть кординаты плитки в метрах
func cooTileInPix(posTile:Vector2):
	return tileMapGround.map_to_world(posTile)
	
	pass
	
#Вернуть кординаты плитки по координатам с экрана
func getCooTileFromCooScreen(point2d):
	return getCooTile(game.map.cameraGame.getCooInMap(point2d))

#Вернуть центр плитки в пикселях
func getCenterTile(tileCoo:Vector2):
	var size=tileMapGround.cell_size
	
	var y2=(size.y/2.0)
	return Vector2((size.x*tileCoo.x)+(size.x/2.0),(size.y*tileCoo.y)+y2+(y2*(tileCoo.x as int%2)));
	

#Блокирована ли ячейка сетки
func isTileBlock(x,y):
	var cell=tileMapGround.get_cell(x,y)
	if cell==Tile.tile_rock:
		return true
		
	return false;
	pass

#Являктся ли потка спайсом
func isTileSpice(x,y):
	var cell=tileMapGround.get_cell(x,y)
	if cell==Tile.tile_spice:
		return true
		
	return false;
	pass


#заблокировать питку, где сейчас юнит
func blockTile(unit):
	var tile=unit.getTileUnit()
	blockedTiles.block(tile,unit)
	pass

#Заблокирована ли плитка для юнита
func isTileBlockForUnit(x,y,unit):
	
	
	if unit!=null:
		if blockedTiles.isBlockTile(Vector2(x,y),unit):
			return true
		
	return false;
	pass


#Вернуть рандомную плитку, на которую можно постаивть юнит
func getRandomNotBlockTile(startTile:Vector2,unit):
	if startTile!=null && unit!=null:
		
		
		var dir:Vector2=Vector2(0,1)
		var i=0
		var c:int=1
		while true:
			
			if isTileBlock(startTile.x,startTile.y):
				
				startTile+=dir*c
				
				
				var x=dir.x
				dir.x=-dir.y
				dir.y=x
				
				i+=1
				if i%2==0:
					c+=1
				if i>1000:
					break
			else:
				return startTile;
			pass
	
	
	pass

#в funcCallBack метод будут передаваться коррдинаты плиток, их можно проверить
#funcCallBack(x,y), вернуть true, что бы продолжать искать далее

func searchTileSpice(startTile:Vector2):
	if startTile!=null:
		
		var dir:Vector2=Vector2(0,1)
		var i=0
		var c:int=1
		while true:
			
			if !isTileSpice(startTile.x,startTile.y):
				
				startTile+=dir*c
				
				dir=dir.rotated(PI/2)
				
				dir.x=dir.x as int
				dir.y=dir.y as int
				
				i+=1
				if i%2==0:
					c+=1
				if i>10000:
					break
			else:
				return startTile;
			pass
	
	pass


#Сгенерировать случайную карту
func generateMap():

	var x=0
	while true:
		var y=0
		while true:
			
			var tileId=Tile.tile_rock
			var num=randf()
			if num>=0.2 && num<0.9:
				tileId=Tile.tile_sand
			if num>=0.9:
				tileId=Tile.tile_spice	
			
			
			
			tileMapGround.set_cell(x,y,tileId)
			
			y+=1
			if y>=mapHeight:
				break;
	
		x+=1
		if x>=mapWidth:
			break;
	
	#====Устанокуа ограницения для камеры
	if cameraGame!=null:
		
		var st=tileMapGround.cell_size
		cameraGame.limit=Rect2(Vector2(st.x/2,st.y/2),Vector2((mapWidth*st.x)-(st.x),(mapHeight*st.y)-(st.y)))
	
	pass



func _init(game,nodeMap,cameraGame:CameraGame).(game):
	
	tileMapGround=nodeMap.get_node("TileMapGround")
	tileMapSelect=nodeMap.get_node("TileMapSelect")
	tileMapSelect.clear()
	tileMapSelect.modulate.a=0.3
	
	self.cameraGame=cameraGame
	
	blockedTiles=TileBlocks.new(game)
	
	
	
	pass

class_name ManagerMap
extends Base

#нету выделения
const SELECT_TYPE_NONE=0
#для выбора куда двигаться
const SELECT_TYPE_MOVE=1
#Выделение пути вдижеия
const SELECT_TYPE_ROAD=2
#Для выдекление клеток для атаки
const SELECT_TYPE_ATTACK=3

#поверхность с плитки
var tileMapGround:TileMap
#Для выделения клеток
var tileMapSelect:TileMap

#Плиток по ширине
var mapWidth=50
#Плиток по высоте
var mapHeight=25

var cameraGame:CameraGame

#Заблокированные плитеи на которые нельзя стать
var blockedTiles:TileBlocks

#констранты SELECT_TYPE_*, какого типа выделение установлено 
var selectType=SELECT_TYPE_NONE

#для какого юнита выдеоено
var unitSelect



#Вернуть массив соседних плиток, vec2int - плитка, для которой нужно получить координаты плиток соседей
func getNightboring(vec2int):
	
	var vecsTiles:Array=[]
	if tileMapGround.cell_half_offset==TileMap.HALF_OFFSET_Y:
		#====
		var x=vec2int.x-1
		var y=vec2int.y
		
		var xt=vec2int.x
		xt=xt as int
		if xt%2==0:
			y-=1
		vecsTiles.push_back(Vector2(x,y))
		
		#===
		x=vec2int.x+1
		y=vec2int.y
		
		xt=vec2int.x as int
		
		if xt%2==0:
			y-=1
		
		vecsTiles.push_back(Vector2(x,y))
		
		#===
		x=vec2int.x+2
		y=vec2int.y
		
		
		vecsTiles.push_back(Vector2(x,y))
		
		#===
		x=vec2int.x+1
		y=vec2int.y
		xt=vec2int.x as int
		if xt%2==1:
			y+=1
		
		vecsTiles.push_back(Vector2(x,y))
		
		#===
		x=vec2int.x-1
		y=vec2int.y
		xt=vec2int.x as int
		if xt%2==1:
			y+=1
		
		vecsTiles.push_back(Vector2(x,y))
		
		#====
		x=vec2int.x-2
		y=vec2int.y
		
		vecsTiles.push_back(Vector2(x,y))
		
	return vecsTiles
	pass


#Вернуть плитку по клике на карту. Картинка плитки может выходить за границы, поэтому нужен этот метод
func getTileByPointPix(vecPix):
	
	
	#Плитка на которую кликнули
	var vec2int=tileMapGround.world_to_map(vecPix)
	
	
	#Соседние плитки
	var dist=9999999
	var tileSelect=vec2int
	
	var nightboring=getNightboring(vec2int)
	if nightboring!=null && nightboring.size()>0:
		if tileMapGround.cell_half_offset==TileMap.HALF_OFFSET_Y:
			for nig in nightboring:
				
				#кордината центра
				var cooCenterTile=tileMapGround.map_to_world(nig) 
				cooCenterTile=tileMapGround.cell_size/2
				var centerToClick=cooCenterTile-vecPix
				
				if centerToClick.length()<=dist:
					tileSelect=nig
				
	return tileSelect	
	
	pass

#очистить выделение
func clearSelect():
	selectType=SELECT_TYPE_NONE
	tileMapSelect.clear()
	unitSelect=null


#Выделить плитки idtile типа tile_select_attack
func selectTileRoad(route,unit,limit):
	selectType=SELECT_TYPE_ROAD
	unitSelect=unit
	
	if route!=null && route.tiles!=null && route.tiles.size()>0:
		tileMapSelect.clear()
		var i=0;
		while true:
			if i<route.tiles.size():
				var tile=route.tiles[i]
				if tile!=null:
					tileMapSelect.set_cell(tile.x,tile.y,Tile.tile_select_move)
				i+=1
				if i>=limit:
					break
			else:
				break
	pass
	
#Выделить плитки для перемещения
func selectTileMove(route,unit):
	selectType=SELECT_TYPE_MOVE
	unitSelect=unit
	
	setTileSelect(route,Tile.tile_select_move)

#Выделить плитки для перемещения
func selectTileAttack(route,unit):
	selectType=SELECT_TYPE_ATTACK
	unitSelect=unit
	
	setTileSelect(route,Tile.tile_select_attack)


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
	
#Вернуть кординаты плитки в пикселях
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



#Разблокировать ранне заблокированную плитку этим юнитом
func unBlockTile(unit):
	if unit!=null:
		if unit.blockTile!=null:
			blockedTiles.unBlock(unit.blockTile,unit)
	pass
	

#заблокировать питку, где сейчас юнит
func blockTile(unit):
	#Разблокировать прежнюю
	unBlockTile(unit)
	
	
	#Блокировака новой
	var tile=unit.getTileUnit()
	unit.blockTile=tile
	blockedTiles.block(tile,unit)
	pass

#Заблокирована ли плитка для юнита
func isTileBlockForUnit(x,y,unit,ignoreUnits):
	
	if unit!=null:
		if blockedTiles.isBlockTile(Vector2(x,y),unit,ignoreUnits):
			return true
		
	return false;
	pass


#Вернуть рандомную плитку, на которую можно постаивть юнит
func getRandomNotBlockTile(startTile:Vector2,unit):
	if startTile!=null && unit!=null:
		
		
		var dir:Vector2=Vector2(0 as int,1 as int)
		var i:int=0
		var c:int=1
		while true:
			
			var checkTile=startTile
			var ch=0
			while true:
				
				if !isTileBlock(startTile.x,startTile.y):
					return checkTile
					
				checkTile+=dir
				ch+=1
				if ch>=c:
					startTile=checkTile
					break
			
			i+=1
			if i==2:
				i=0
				c+=1
				
			var x=dir.x
			dir.x=-dir.y
			dir.y=x
			

			if c>1000:
				break
			
			
			pass
		
	
	
	pass

#в funcCallBack метод будут передаваться коррдинаты плиток, их можно проверить
#funcCallBack(x,y), вернуть true, что бы продолжать искать далее

func searchTileSpice(startTile:Vector2):
	if startTile!=null:
		
		
		var dir:Vector2=Vector2(0 as int,1 as int)
		var i:int=0
		var c:int=1
		while true:
			
			var checkTile=startTile
			var ch=0
			while true:
				
				if isTileSpice(checkTile.x,checkTile.y):
					return checkTile
					
				checkTile+=dir
				ch+=1
				if ch>=c:
					startTile=checkTile
					break
			
			i+=1
			if i==2:
				i=0
				c+=1
				
			var x=dir.x
			dir.x=-dir.y
			dir.y=x
			

			if c>1000:
				break
			
			
			pass
	
	pass

func testTiles(startTile:Vector2):
	if startTile!=null:
		
		var dir:Vector2=Vector2(0 as int,1 as int)
		var i:int=0
		var c:int=1
		while true:
			
			var checkTile=startTile
			var ch=0
			while true:
				
				if true:
					tileMapGround.set_cell(checkTile.x as int,checkTile.y as int,-1)
					
				else:
					return checkTile;
				checkTile+=dir
				ch+=1
				if ch>=c:
					startTile=checkTile
					break
			
			i+=1
			if i==2:
				i=0
				c+=1
				
			var x=dir.x
			dir.x=-dir.y
			dir.y=x
			

			if c>1000:
				break
			
			
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

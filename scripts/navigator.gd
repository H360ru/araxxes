
class_name Navigator
extends Base

#Для какого юнита проверяется маршрут
var checkUnit
var ignoreTo;
var ignoreUnits

#построить маршрут Route, или вернет null, если этого сделать невозможно
#limitStep - Использовать для получения карты возможности движения или атака к примеру
#ignoreTo - если не интересует конечная плитка какая она
#unit - для какого юнита строить маршрут
func buildRoute(from:Vector2,to:Vector2,checkBlock,limitStep=-1,ignoreTo=false,unit=null,ignoreUnits=null):
	
	var manmap:ManagerMap=game.map.manMap
	
	var tileFrom=manmap.tileMapGround.world_to_map(from);
	var tileTo=manmap.tileMapGround.world_to_map(to);
	
	var cellFrom=manmap.tileMapGround.get_cell(tileFrom.x,tileFrom.y)
	var cellTo=manmap.tileMapGround.get_cell(tileTo.x,tileTo.y)
	
	checkUnit=unit
	self.ignoreTo=ignoreTo
	self.ignoreUnits=ignoreUnits
	
	if cellFrom!=-1 && (cellTo!=-1 || ignoreTo):
		
		
		#====Проверка блокировки для юнита
		
		var isBlock=manmap.isTileBlockForUnit(tileTo.x,tileTo.y,unit,ignoreUnits)
		if isBlock==false:
			isBlock=manmap.isTileBlock(tileTo.x,tileTo.y)
			
			
		#======
		if (isBlock==false || ignoreTo) || checkBlock==false:
			
			#проверенные плитки
			var tilesCheked:Array=[]
			var indexArrayCheck=0;
			
			
			var countStep=0
			var nextStep=0
			
			#построить ли маршрут
			var build=false
			
			var tileStart=RouteTile.new(tileFrom.x,tileFrom.y,countStep)
			tilesCheked.push_back(tileStart)
			
			while true:
				
				
				var chTile=tilesCheked[indexArrayCheck]
				
				if (chTile.x==tileTo.x && chTile.y==tileTo.y) || build:
					
					#получаем маршрут
					var route=Route.new();
					route.build(tileStart,chTile)
					route.arrTiles=tilesCheked
					route.arrTilesLimit=indexArrayCheck
					checkUnit=null
					return route
					
				#Получаем соседние плитки
				
				#========================
				if manmap.tileMapGround.cell_half_offset==TileMap.HALF_OFFSET_Y:
					#====
					var x=chTile.x-1
					var y=chTile.y
					if chTile.x%2==0:
						y-=1
					checkNewTile(tilesCheked,chTile,x,y,countStep)
					
					
					#===
					x=chTile.x+1
					y=chTile.y
					if chTile.x%2==0:
						y-=1
					
					checkNewTile(tilesCheked,chTile,x,y,countStep)
					
					
					#===
					x=chTile.x+2
					y=chTile.y
					
					
					checkNewTile(tilesCheked,chTile,x,y,countStep)
					
					#===
					x=chTile.x+1
					y=chTile.y
					if chTile.x%2==1:
						y+=1
					
					checkNewTile(tilesCheked,chTile,x,y,countStep)
					#===
					x=chTile.x-1
					y=chTile.y
					if chTile.x%2==1:
						y+=1
					
					checkNewTile(tilesCheked,chTile,x,y,countStep)
					#====
					x=chTile.x-2
					y=chTile.y
					
					checkNewTile(tilesCheked,chTile,x,y,countStep)
				
				#=====================
				if manmap.tileMapGround.cell_half_offset==TileMap.HALF_OFFSET_DISABLED:
					#====
					var x=chTile.x-1
					var y=chTile.y
					checkNewTile(tilesCheked,chTile,x,y,countStep)
					
					x=chTile.x
					y=chTile.y-1
					checkNewTile(tilesCheked,chTile,x,y,countStep)
					
					x=chTile.x+1
					y=chTile.y
					checkNewTile(tilesCheked,chTile,x,y,countStep)
					
					x=chTile.x
					y=chTile.y+1
					checkNewTile(tilesCheked,chTile,x,y,countStep)
					
					
				#=============
				
				#=====количество шагов
				if indexArrayCheck==nextStep:
					countStep+=1
					nextStep=tilesCheked.size()-1
					
				if (limitStep!=-1 && countStep>=limitStep):
					
					build=true
					
				
				indexArrayCheck+=1
				
				if tilesCheked.size()==indexArrayCheck:
					break
			
			pass
			
		else:
			#конечная плитка заблокирована не пройти
			pass
		
		pass
	else:
		#Не возможно посторить маршрут, нету плиток
		pass
	
	checkUnit=null
	
	pass


#Добавить новую плитку в маршруте. arr - проверенные плитки, chtile - плитка с которой проверяем следующую, x,y - координат новой плитки
func checkNewTile(arr,chTile,x,y,step):
	
	if issetTile(arr,x,y)==false && checkTile(x,y):
		var addtile=RouteTile.new(x,y,step)
		
		chTile.next.push_back(addtile)
		addtile.prev.push_back(chTile)
		
		arr.push_back(addtile)
	pass

#есть ли в массвие плиток RouteTile плитка с координатами x,y
func issetTile(arr,x,y):
	for tile in arr:
		if tile!=null:
			if tile.x==x && tile.y==y:
				return true
	return false
	
	pass

#Можно ли быть на плитке
func checkTile(x,y):
	if game.map.manMap.tileMapGround.get_cell(x,y)!=-1 && game.map.manMap.isTileBlock(x,y)==false && (game.map.manMap.isTileBlockForUnit(x,y,checkUnit,ignoreUnits)==false):
		return true
	return false;
	
	
	
	
	pass


func _init(game).(game):
	
	
	pass

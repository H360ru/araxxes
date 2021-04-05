class_name Unit
extends Base

#Нод юнита, спрайт
var node:Sprite;

#параметры с имени нода
var params:Array=[]

#Фреймы показывающие последовательный поворот
var rotationFrames=[]
#В какую сторону поворот, -1 - против часовой
var rotationDirection=-1
#повоорот который установлен в начальном фрейме
var rotationStartRad=Vector2(0,1)


#навигатор, что бы знать куда ехать
var navigator:Navigator

#Для передвижения
var uMove:UnitMove;

#Чей юнит
var player:Player

#последняя плитка на которой был юнит
var lastTileFree
#Имя юнита
var name
#Закончил ли ход юнит
var ended=false

#пок акому маршруту двигался или двигается юнит
var route
#последний маршрут для передвижения
var routeSelectMove

var states:UnitStates

#запщищен ли юнит на тур
var isSafe=false

#Скольок клеток по цене moveX1Point очков за клетку
var moveX1Len
#Скольок клеток по цене moveX2Point очков за клетку
var moveX2Len
#Скольок очков на 1 шаг
var moveX1Point
#Скольок очков на 1 шаг
var moveX2Point

#Атака очков на 2 клеки
var pointArrack
#Собрать спайс
var pointSpice
#защититься
var pointSafe

#последние параметры ходов и цены
var hoSteps

#Можно ли двигаться при клике
var canMove=false

#Заблокированная плитка
var blockTile:Vector2




#на кой плите юнит
func getTileUnit():
	var cooC=getUnitTileCenter()
	if cooC!=null:
		return game.map.manMap.getCooTile(cooC)

#Может ли юнит взять спайс, вернет false, если не над плиткой, ли не хватает очков
func isTakeSpace():
	var tile=getTileUnit()
	if tile!=null:
		if game.map.manMap.isTileSpice(tile.x as int,tile.y as int):
			if player.points>=pointSpice:
				return true
	return false
	
#Взять спайс
func takeSpace():
	if isTakeSpace():
		var tile=getTileUnit()
		game.map.manMap.setTileSand(tile.x,tile.y)
		player.minusPoints(pointSpice)
		player.spices+=1
		game.refreshPlayerLabel(player)
		
	
	pass

#Вернуться назад в ходе
func backState():
	states.laod()
	game.refreshPlayerLabel(player)
	
func saveSave():
	states.save()
	pass

#Можно ли установить защиту, если уже установлена, то вернет что нельзя
func isSafeSet():
	return isSafe==false && player.points-pointSafe>=0


#Защититься, если хватит очков
func safe():
	if isSafe==false:
		if isSafeSet():
			player.minusPoints(pointSafe)
			isSafe=true
			
	game.refreshPlayerLabel(player)
	pass

#подсветить плитки для перемещения, куда и сколько можно переместиться
func selecTilesForMove():
	
	if player!=null:
		#Скольок можно ходить
		hoSteps=self.getStepsByPoint(player.points)
		if hoSteps!=null:
			if hoSteps[0]<4:
				hoSteps[0]+=1
			routeSelectMove=getTilesMap(hoSteps[0],self)
			game.map.manMap.setTileSelect(routeSelectMove,Tile.tile_select_move)
			
			pass
	pass

#Скольок юнит может ходить на заданные очки, и сколько остается очкоа
func getStepsByPoint(points:int):
	
	
	#Скольок шагов можно сделать
	var steps=0
	#Скольок потратится
	var pointsleft=0
	
	#==x1
	if points>0:
		var stepsX1=(points/moveX1Point) as int
		stepsX1=min(stepsX1,moveX1Len)
		steps+=stepsX1
		pointsleft+=stepsX1*moveX1Point
	
	#==x2
	if points>0:
		var stepsX2=(points/moveX2Point) as int
		steps+=stepsX2
		pointsleft+=stepsX2*moveX2Point
			
	
	return [steps,pointsleft]
	pass

#Скольок очков на заданное количестов шагов, должно потратиться
func getPointsByStep(steps:int):
	
	
	
	if steps<=moveX1Len:
		#Все очки по цене x1
		return steps*moveX1Point
	else:
		#Все очки по цене x1 и остальные по x2
		return (moveX1Len*moveX1Point)+((steps-moveX1Len)*moveX2Point)
	
	
	pass

#позиция юнита на экране
func getPosInScreen():
	var cam:CameraGame=game.map.cameraGame
	
	if cam!=null:
		
		var rectCam:Rect2=cam.getRectCam()
		var posUnit=getCooUnitInMap()
		return cam.nodeCamera2d.get_viewport().size*((posUnit-rectCam.position)/rectCam.size)
	
	
	pass

#передвигается ли сейчас юнит
func isRunning():
	return uMove.end==false

#Установить юнит в плитку
func setInTile(x,y):
	
	var cooPix=game.map.manMap.getCenterTile(Vector2(x,y))
	uMove.pos=game.map.di.pixToM(cooPix)
	
	pass


#Вернуть плитки дял атаки или передвижения
func getTilesMap(limitStep,unit):
	
	var cooPam=getUnitTileCenter()
	
	var route:Route=self.navigator.buildRoute(cooPam,cooPam+Vector2(99999,99999),true,limitStep,true,unit);
	return route;
	
	pass


#Вернуть координаты югита на карте
func getCooUnitInMap():
	return game.map.di.mToPix(self.uMove.pos)
	

#получить координаты центра плитки, на которой был или есть юнит
func getUnitTileCenter():
	var cooPam
	if lastTileFree==null:
		cooPam=getCooUnitInMap()
	else:
		cooPam=game.map.manMap.getCenterTile(lastTileFree)
		
	return cooPam
	pass

#Указать юниту двигаться на плитку
func moveToTile(vec2d,limitsStep):
	
	if navigator!=null:
		
		#uMove.pos=game.map.di.pixToM(vec2d);
		
		var cooPam=getUnitTileCenter()
		var route:Route=self.navigator.buildRoute(cooPam,vec2d,true,limitsStep,false,self);
		moveOnRoute(route,limitsStep,0)
		pass
	pass


#начать двигаться по маршруту, лимит шагов
func moveOnRoute(route,limitStep,offsetBack):
	if route!=null:
		
		
		var pointsMap=route.getPoints(limitStep,offsetBack)
		
		var i=0;
		while true:
			var cooTile=pointsMap[i]
			var cooMap=game.map.manMap.getCenterTile(cooTile)
			#var tile=game.map.manMap.getCooTile(cooMap)
			
			cooMap=game.map.di.pixToM(cooMap)
			pointsMap[i]=cooMap
			i+=1
			if i>=pointsMap.size():
				break
				
				
		self.route=route
		 
		
		self.uMove.setMovePoints(pointsMap)
	pass


func run(delta):
	
	
	var manMap=game.map.manMap
	
	#==============перемещнеие
	
	
	if uMove!=null:
		uMove.run(delta)

		
		#Определение кадра юнита
		node.frame=getFrame()
		
		#позицуия бнгита на карте
		var pixpos=getCooUnitInMap()
		node.transform.origin=pixpos
		
		
		#Определить на какой плитке юнит
		var tile=manMap.getCooTile(pixpos)
		if manMap.isTileBlock(tile.x,tile.y)==false:
			lastTileFree=tile
	
	
	
	pass
	

#Вернуть кадр, который нужно устанавливать согласно повороту юнита
func getFrame():
	if rotationFrames!=null && rotationFrames.size()>0:
		
		var rad=uMove.direction.angle_to(Vector2(1,0))
		
		
		rad-=(PI/2)
		var index=rad/PI
		var frame=(rotationFrames.size()/2)*index
		if rad<0:
			frame=rotationFrames.size()-abs(frame)
		
		
		return rotationFrames[frame]
		
	return 0;
	pass


func _init(game,node,name).(game):
	self.node=node
	self.name=name
	
	params=node.name.split("_")
	
	navigator=Navigator.new(game);
	
	uMove=UnitMove.new(game,self)
	
	
	states=UnitStates.new(game,self)
	
	#настройки отдельно для каждого юнита
	if name=="harvestr":
		moveX1Len=6
		moveX2Len=12
		moveX1Point=1
		moveX2Point=3
		
		pointArrack=999999
		
		pointSafe=2
		pointSpice=1
		
	if name=="worm":
		moveX1Len=5
		moveX2Len=10
		moveX1Point=1
		moveX2Point=3
		
		pointArrack=3
		
		pointSafe=9999999
		pointSpice=99999
	
	
	pass

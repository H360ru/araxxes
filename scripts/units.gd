
class_name Units
extends Base



#Вызывается при клике на юнита
signal onClickUnit(units,unit,sceenPos)

#Юниты которые двигаются  втекущйи момент
var unitsMove:Array=[]

#Массив югитов, которые двигаются
var arrUnits:Array=[]


#Вернуть юнит по минимальной дистанции от камеры
func getUnitByMinDist(posPix):
	if posPix is Vector2:
		var minDist=99999999
		var unitRet
		for u in arrUnits:
			if u!=null:
				var dist=(posPix-u.getCooUnitInMap()).length()
				if dist<minDist:
					minDist=dist
					unitRet=u
		return unitRet			
	pass

#Вернуть юнит по ноду
func getUnitByNode(node):
	if node!=null:
		for u in arrUnits:
			if u!=null:
				if u.node==node:
					return u

#Вернуть юниты а плитке
func getUnitsInTile(vec2int):
	var unitsInTile:Array=[]
	if vec2int!=null && vec2int is Vector2:
		for chu in arrUnits:
			if chu!=null && chu.stopTile!=null:
				if chu.stopTile==vec2int:
					unitsInTile.push_back(chu)
					
	return unitsInTile				
	pass

#Вернуть юнита по имени
func getByName(name):
	for u in arrUnits:
		if u!=null:
			if u.name==name:
				return u
				

#Установка парамеитров в начале хода
func refreshEndedBYPlayer(player):
	if player!=null:
		for u in arrUnits:
			if u!=null:
				if u.player==player:
					u.ended=false
					u.isSafe=false
					#Очистить состояния
					u.states.clear()
					
	pass

#Проверить конец хода для игрока и передать ход другому игроку
func checkEndTurnByPlayer(player):
	
	if player!=null:
		
		var endTurn=true
		for u in arrUnits:
			if u!=null:
				if u.player==player:
					if u.ended==false:
						endTurn=false
						break;
		
		if endTurn:
			game.queue.nextPlayer()


#Закончить ход всем юнитам после того ка кони закончат свое действие
func checkEndedAfterEnd(player):
	
	if player!=null:
		for u in arrUnits:
			if u!=null:
				if u.player==player:
					if u.isRunning()==false:
						u.ended=true
						
		


#Вернуть всех юнитов для игрока returnEnded - вернуть ли завершивших ход. limit - максимум сколько
func getUnitsPlayer(player,returnEnded,limit):
	
	if player!=null:
		
		var i=0
		var units:Array=[]
		for u in arrUnits:
			if i<limit:
				if u!=null:
					if u.player==player:
						if (returnEnded || u.ended==false):
							units.push_back(u)
							i+=1
						
					
			else:
				break
			
		return units
	pass	
		
#Вурнуть юнитов других игроков		
func getUnitsOtherPlayer(player,limit):
	
	if player!=null:
		
		var c=0
		var units:Array=[]
		for u in arrUnits:
			if u!=null:
				if u.player!=player:
					units.push_back(u)
					c+=1
					if c>=limit:
						break
		return units
	pass					
					
#Добавить юнит по ноду
func addUnit(node,name):
	
	
	var un=Unit.new(game,node,name)
	arrUnits.push_back(un)
	
	
	var arrFrames=[]
	var count=un.params[1] as int
	var i=0
	while true:
		arrFrames.push_back(i)
		i+=1
		if i==count:
			break
			
	un.rotationFrames=arrFrames
	
	un.uMove.connect("onUnitMoveStart",self,"onUnitMoveStart")
	un.uMove.connect("onUnitMoveFinished",self,"onUnitMoveFinished")
	un.uMove.connect("onUnitMoveStop",self,"onUnitMoveStop")
	
	return un
	pass
	
#Вызывается при начале движения юнита
func onUnitMoveStart(unit):
	if unit!=null:
		if unitsMove.find(unit)==-1:
			unitsMove.push_back(unit)
	
	pass


func onUnitMoveStop(unit):
	#Бллокировака кетки		
	if unit!=null:
		var idU=unitsMove.find(unit)
		if idU!=-1:
			unitsMove.remove(idU)
	
	
	game.map.manMap.clearSelect()
	
	#HACK: вроде исправление бага лейблов
	#game.refreshPlayerLabel(unit.player)
	
	pass

#Вызывается при начале окончания движения
func onUnitMoveFinished(_unit):
	pass

func checkNode(node):
	if node.name.find("sp_unit")==0:
		
		pass
	pass
	
	
#Удалить всех унитов
func clear():
	for unit in arrUnits:
		if unit!=null:
			var par=unit.node.get_parent()
			if par!=null:
				par.remove_child(unit.node)
	arrUnits=[]

	
#Вызывается при клике по карте
func onClickMap(vec2d:Vector2):
	
	

	var player=game.queue.getThisPlayer()
	var inMap=game.map.manMap.getCooTile(vec2d)
	#var inMap=game.map.manMap.getTileByPointPix(vec2d)
	var nextEvent=true
	
	for unit in arrUnits:
		if unit!=null:
			if unit.node.get_rect().has_point(unit.node.to_local(vec2d)):
				emit_signal("onClickUnit",self,unit,vec2d)
				nextEvent=false
				
	
	#=====================провера клика по выделениям		
	if nextEvent && player!=null:
		#===========перемещения юнита
		var unit=game.unUnitMenu.unit
		if unit!=null && game.map.manMap.selectType==ManagerMap.SELECT_TYPE_MOVE && unit==game.map.manMap.unitSelect:# game.unUnitMenu.unit.canMove:
			
			
			#на выделенной плитке ли кликнули
			var routeSelect=unit.routeSelectMove
			if routeSelect!=null:
				
#				var hoSteps=unit.hoSteps
				
				var indexStep=routeSelect.containTile(inMap)
				if indexStep!=-1:
					
					#передвижение
					#unit.canMove=false
					unit.moveToTile(vec2d,-1)
					game.unUnitMenu.close()
					
					#=====Убрать очки
					var pointsMinu=unit.getPointsByStep(indexStep+1)
					unit.player.minusPoints(pointsMinu)
				
				
			
		if unit!=null && game.map.manMap.selectType==ManagerMap.SELECT_TYPE_ATTACK && unit==game.map.manMap.unitSelect:# game.unUnitMenu.unit.canMove:
			#======проверка выбора атаки
			var routeSelect=unit.routeSelectAttack
			if routeSelect!=null:
				
				var indexStep=routeSelect.containTile(inMap)
				if indexStep!=-1:
					#поиск врага в плитке
					var units=game.map.units.getUnitsInTile(inMap)
					if units!=null && units.size()>0:
						pass
					pass
			
			pass			
					
					
			
	
	
	pass
	
func run(delta):
	
	
	for u in arrUnits:
		if u!=null:
			u.run(delta)
			
	
	#=======Выделение маршрута для движещихся юнитов
	if unitsMove!=null && unitsMove.size()>0:
		var forUnitSleect=unitsMove[unitsMove.size()-1]
		if forUnitSleect.isRunning():
			if forUnitSleect.route!=null && forUnitSleect.uMove.movePoints!=null:
				var limit=forUnitSleect.uMove.movePoints.size()
				game.map.manMap.selectTileRoad(forUnitSleect.route,forUnitSleect,limit)
				pass
	
		pass

func input(_e):
	pass

func _init(game).(game):
	pass

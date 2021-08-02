#Для движения юнита

class_name UnitMove
extends Base

#Вызываетсяпри начале движения
signal onUnitMoveStart(unitMove)
#Вызываетсяпри начале окончания движения
signal onUnitMoveFinished(unitMove)
#когда юнит останавливается
signal onUnitMoveStop(unitMove)
#когда юнит проехал тайл
#signal onUnitMoveStop(unitMove)

var unit
#направление юнита
var direction:Vector2=Vector2(1,1)

#позиция юнита
var pos:Vector2=Vector2(0,0)
var lastPos:Vector2

#Масив точке Vector2, для последовательного двидения
var movePoints:Array=[];

#Точка на которую двигаться
var thisPoint=0;

#60,2,2
var speed:SpeedM=SpeedM.new(15,2,2,0)

#Установились ли на точку, что бы потом по линии
var setToPoint=false

#Двигается ли юнит к точке
var end=true;
#Остановился ли юнит полностью
var stopped=true


#Устновить точки для передвижения
func setMovePoints(_movePoints):
	self.movePoints = _movePoints
	thisPoint=0
	end=false
	
	emit_signal("onUnitMoveStart",self.unit)
	

#Закончить двигаться. При этом юнит может продолжать останавливаться
func endMove():
	end=true
	emit_signal("onUnitMoveFinished",self.unit)
	
	pass
	
#перемещаться	
func move(delta):
	
	
	speed.scale=game.setting.speed
	
	speed.run(delta)
	
	if movePoints!=null && movePoints.size()>0:
		
		if end==false:
			var poi=movePoints[thisPoint]
			var vecToPoint:Vector2=poi-pos;
		
			#========Передвижение
			
			var rotTo=direction.angle_to(vecToPoint)
		
			if abs(rotTo)<PI/2:
				speed.move=true
			else:
				speed.move=false
				
			
			#========Вращение
			
			direction=direction.rotated(((rotTo/10)*speed.scale)*(speed.maxSpeed)/60.0)
			
			#======Следт точка
			
			if pos.distance_to(poi)<20:
				# #prints('Проехал', game.map.manMap.getCooTile(game.map.di.mToPix(poi)))
				# #prints('Hex center', poi)
				# #prints('lastTileFree', unit.lastTileFree)
				# #prints('getTileUnit', unit.getTileUnit())
				if unit.name == "harvestr":
					var _tile = game.map.manMap.getCooTile(game.map.di.mToPix(poi))#unit.getTileUnit()#lastTileFree
					if game.map.manMap.isTileSpice(_tile.x as int, _tile.y as int):
						# #prints('Spice at',_tile.x,_tile.y)
						game.map.manMap.setTileSand(_tile.x,_tile.y)
						unit.player.spices+=1
						game.refreshPlayerLabel(unit.player)

				if thisPoint<movePoints.size()-1:
					thisPoint+=1
				else:
					endMove()
				 
		else:
			speed.move=false	
	else:
		speed.move=false
		
	var moveadd=direction.normalized()*speed.thisSpeed
	
	pos+=moveadd
	
	#=======Остановка
	if moveadd.length()<0.001:
		if stopped==false:
			unit.onUnitStop()
			emit_signal("onUnitMoveStop",self.unit)
		stopped=true
	else:
		stopped=false
	
	pass	
	
func run(delta):
	
	
	move(delta)
	
	lastPos=pos;
			
	
	
	pass

func _init(game, _unit).(game):
	self.unit = _unit
	pass

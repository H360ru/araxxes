class_name UnitSatate
extends Base

var unit

#Очки
var points
#позиция юнита
var pos
#направлени юнита
var direction
#Защита
var isSafe
var spices

var isSaved=false

#Сохраниеть состояния  сюнита
func saveState():
	
	points=unit.player.points
	pos=unit.uMove.pos
	direction=unit.uMove.direction
	isSafe=unit.isSafe
	spices=unit.player.spices
	
	isSaved=true
	
	
	pass
	
#Устанвоить состояние юнита
func loadState():
	if isSaved:
		unit.player.points=points
		unit.uMove.pos=pos
		unit.uMove.direction=direction
		unit.isSafe=isSafe
		unit.player.spices=spices
	pass
	

func _init(game,unit).(game):
	self.unit=unit
	pass


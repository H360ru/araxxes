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
var isSpiceCollected=false

#Сохраниеть состояния  сюнита
func saveState(_isSpiceCollected=false):
	
	points=unit.player.points
	pos=unit.uMove.pos
	direction=unit.uMove.direction
	isSafe=unit.isSafe
	spices=unit.player.spices
	
	isSaved=true
	
	isSpiceCollected = _isSpiceCollected
	pass
	
#Устанвоить состояние юнита
func loadState():
	if isSaved:
		unit.player.points=points
		unit.uMove.pos=pos
		unit.uMove.direction=direction
		unit.isSafe=isSafe
		unit.player.spices=spices

		if isSpiceCollected:
			returnSpice()
	pass
	

func _init(game, _unit).(game):
	self.unit = _unit
	pass


func returnSpice():
	# var tile=unit.getTileUnit()
	for _tile in isSpiceCollected:
		game.map.manMap.tileMapGround.set_cell(_tile.x,_tile.y,Tile.tile_spice)

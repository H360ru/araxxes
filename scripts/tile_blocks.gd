
#Для контроля забллоокированных плиток
class_name TileBlocks
extends Base

#заблокированные плитки
var tiles:ArrayRect

#заблокирована ли плитка для юнита
func isBlockTile(vecint,unit,ignoreUnits):
	var tileB:TileBlock=tiles.getV(vecint)
	if tileB!=null:
		return tileB.isBlockForUnit(unit,ignoreUnits)
		
	return false
	pass
	


#Заблокировать плитку юнитом vecint - Vector2
func block(vecint,unit):
	if vecint!=null && unit!=null:
		var tileB:TileBlock=tiles.getV(vecint)
		if tileB==null:
			tileB=TileBlock.new(vecint)
		
		
		tileB.addUnit(unit)
		
		tiles.setV(vecint,tileB)
		
	pass
	

#разблокировать плитку
func unBlock(vecint,unit):
	
	var tileB:TileBlock=tiles.getV(vecint)
	if tileB!=null:
		tileB.removeUnit(unit)
		tiles.setV(vecint,tileB)
		
	pass

func _init(game).(game):
	
	tiles=ArrayRect.new(1000,1000)
	
	pass


#Для контроля забллоокированных плиток
class_name TileBlocks
extends Base

#заблокированные плитки
var tiles:ArrayRect

#заблокирована ли плитка для юнита
func isBlockTile(vecint,unit):
	var tileB:TileBlock=tiles.getV(vecint)
	if tileB!=null:
		return tileB.isBlockForUnit(unit)
		
	return false
	pass
	


#Заблокировать плитку юнитом vecint - Vector2
func block(vecint,unit):
	if vecint!=null:
		var tileB:TileBlock=tiles.getV(vecint)
		if tileB==null:
			tileB=TileBlock.new(vecint)
		if unit!=null:
			tileB.addUnit(unit)
		
		
		tiles.setV(vecint,tileB)
		
	pass
	
#разблокировать плитку
func unBlock(vecint,unit):
	
	var tileB:TileBlock=tiles.getV(vecint)
	tileB.removeUnit(unit)
	if tileB.units.size()==0:
		tiles.setV(vecint,null)
		
	pass

func _init(game).(game):
	
	tiles=ArrayRect.new(1000,1000)
	
	pass

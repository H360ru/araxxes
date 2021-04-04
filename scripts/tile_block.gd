
#Заблокированная плитка
class_name TileBlock
extends Object

#координата заблокированной плитки
var xy:Vector2


#Кем заблокирована плитка, в массиве обїекті Unit
var units:Array=[]


#Заблокирвоана ли плитка для юнита
#ignoreUnits - юниты которых не нужно учитывать
func isBlockForUnit(unit,ignoreUnits):
	
	if ignoreUnits==null:
		
		var exist=units.find(unit)
		if (exist==-1 && units.size()>0) || (exist!=-1 && units.size()>1):
			return true
	else:
		
		for unitcheck in units:
			if unitcheck!=unit && ignoreUnits.find(unitcheck)==-1:
				return true
	return false
	pass

func addUnit(unit):
	if units.find(unit)==-1:
		units.push_back(unit)
	pass
	
	
func removeUnit(unit):
	var ind=units.find(unit)
	if ind!=-1:
		units.remove(ind)

func _init(xy):
	self.xy=xy
	pass


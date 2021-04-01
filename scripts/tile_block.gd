
#Заблокированная плитка
class_name TileBlock
extends Object

#координата заблокированной плитки
var xy:Vector2


#Кем заблокирована плитка, в массиве обїекті Unit
var units:Array=[]

#Заблокирвоана ли плитка для юнита
func isBlockForUnit(unit):
	if (units.find(unit)==-1 && units.size()>0) || (units.find(unit)!=-1 && units.size()>1):
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


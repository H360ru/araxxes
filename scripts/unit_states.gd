
class_name UnitStates
extends Base

#Для какого юнита сохранянть сотояние
var unit
var states:Array=[]


#Очистить сохранения
func clear():
	states=[]
	pass

#есть ли сохранения
func issetSave():
	return states.size()>0

func save():
	var unitState=UnitSatate.new(game,unit)
	unitState.saveState()
	states.push_back(unitState)
	

func laod():
	if states.size()>0:
		var state=states[states.size()-1]
		state.loadState()
		states.remove(states.size()-1)
	pass

func _init(game,unit).(game):
	self.unit=unit
	pass

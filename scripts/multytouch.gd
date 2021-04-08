
#Для работы с мульитачем
class_name MultyTouch
extends Base

#Вызываетс при начале мультитача. касаний больше 1
signal onMultyTouchStart()
#Вызываетс при окончании мультитача. касаний 1
signal onMultyTouchFinish(removed)
#Вызывается когда происходит перемезение одного или более пальцев в процессе с несколькими нажатыми пальцами
signal onMultyTouchRun()
#Воод мультитачный ли сейчас
var isMult=false
#Время начала взаимодействия
var timeTouccStart
#Время взаимодействия 
var timeTouch

#Текущие касания
var touchs:Array=[]



func getCoeffDistTouch():
	if isMult && touchs.size()>1:
		var t1=touchs[0]
		var t2=touchs[1]
		var lenStart=(t1.startT-t2.startT).length()
		var lenThis=(t1.thisT-t2.thisT).length()
		return lenStart/lenThis
	return 1
		
	pass

#Вернуть касание по индексу
func getTouchByIndex(index):
	for t in touchs:
		if t!=null && t.index==index:
			return t
			
	pass
	
#Добавить касанеи при начальном таче
func addTouch(index,vec):
	var tou=Touch.new(index)
	tou.start(vec)
	touchs.push_back(tou)
	
	if touchs.size()>1:
		isMult=true
		emit_signal("onMultyTouchStart")
	pass


#Удалить касание
func removeTouch(index):
	
	var removed=false
	var id=0
	for t in touchs:
		
		if t!=null && t.index==index:
			touchs.remove(id)
			removed=true
			
		id+=1	
	
	
	if touchs.size()<2:
		isMult=false
		emit_signal("onMultyTouchFinish",removed)
	pass

func input(e):
	
	var nextEvent=true
	#===============
	if e is InputEventScreenTouch:
		var sct:InputEventScreenTouch=e;
		
		if sct.pressed:
			#начало какогото касания
			if touchs.size()==0:
				timeTouccStart=OS.get_system_time_msecs()
				
			addTouch(sct.index,sct.position)
			
		else:
			#Касание закончено
			removeTouch(sct.index)
			
			if touchs.size()==0 && timeTouccStart!=null:
				timeTouch=OS.get_system_time_msecs()-timeTouccStart
			
		nextEvent=false
		
	#===============
	
	if e is InputEventScreenDrag:
		var sct:InputEventScreenDrag=e;
		
		var tou=getTouchByIndex(sct.index)
		if tou!=null:
			tou.this(sct.position)
			
		emit_signal("onMultyTouchRun")
			
		nextEvent=false
		
	return nextEvent		
	pass

func _init(game).(game):
	pass


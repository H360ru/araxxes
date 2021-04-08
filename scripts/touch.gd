class_name Touch
extends Object

#Для какого касания
var index
#Начальное касание
var startT:Vector2
#Конечное касание
var finishT:Vector2
#Текущее касание
var thisT:Vector2

#Вызвать при начале касания
func start(vec):
	startT=vec
	
#Вызвать при передвижении касания
func this(vec):
	thisT=vec
#Вызвать при окончании касания
func finish(vec):
	finishT=vec

func _init(index):
	self.index=index
	pass


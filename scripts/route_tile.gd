
#Маршрут состоит с плиток.

class_name RouteTile
extends Object

#массив объектов RouteTile, на который можно перейти
var next:Array=[];
#массив объектов RouteTile, на который можно перейти в обратном направлении
var prev:Array=[]

#Кординаты в сетке тайлов
var x:int=0
var y:int=0;

#На каком шаге плитка
var step=0



func _init(x,y,step):
	self.x=x
	self.y=y
	self.step=step
	pass



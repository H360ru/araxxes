class_name Dimension
extends Object


#===================Для размеров согласно плиткам


var sizeTileX=1920
var sizeTileY=1458

#Масштаб сколько пикселей на метр
var scaleX=sizeTileX as float/60.0
var scaleY=sizeTileY as float/70.0


#Пиксели в метры
func pixToM(vec:Vector2):
	
	vec.x/=scaleX
	vec.y/=scaleY
	
	return vec
	
	pass



#метры в пиксели
func mToPix(vec:Vector2):
	
	vec.x*=scaleX
	vec.y*=scaleY
	
	return vec
	
	pass

func _init():
	pass

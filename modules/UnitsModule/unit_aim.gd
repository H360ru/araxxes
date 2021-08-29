extends Reference

class_name UnitAim

# Класс только для запаковывания схожих данных в один объект
# Класс гарантирует правильность даных для конкретного юнита,
# при условии получениия объекта из валидных источников. 
# т.е. все поля расчитаны для конкретного экземпляра юнита, с 
# учетом баффов и всего такого ситуативного

var global_pixel_aim:Vector2
var cell_to_damage:Vector2
var trajectory:Curve2D
var shoot_cost:int

func _init():
	global_pixel_aim = Vector2()
	cell_to_damage = Vector2()
	trajectory = Curve2D.new()
	shoot_cost = 0

extends Reference

class_name MiscFunctions

# Надеюсь, что этот модуль временное решение)

static func get_curve_from_points(points:PoolVector2Array) -> Curve2D:
	var curve:Curve2D = Curve2D.new()
	
	for i in points:
		curve.add_point(i)
	
	var npoints:int = curve.get_point_count()
	for i in range(npoints):
		if i == 0 or i == npoints-1:
			continue
			
		var left = curve.get_point_position(i-1)
		var mid = curve.get_point_position(i)
		var right = curve.get_point_position(i+1)
		
		var n1 = (mid-left).normalized()
		var n2 = (mid-right).normalized()
		
		if (n1+n2).length() <= 0.1: # почти прямая, поэтому сглаживание не нужно
			continue
		
		var normal = (n1+n2).tangent().normalized()
		
		var grade = ((left-mid).length() + (right-mid).length()) / 2 / 4 # разделить на два - ср. ар. и еще на 4 - просто подобранная константа
		
		if (mid+normal-right).length() < (mid-normal-right).length():
			grade *= -1
		
		curve.set_point_in(i, normal*grade)
		curve.set_point_out(i, -normal*grade)
		
	return curve

class_name ArrayRect
extends Object

var arr:Array=[]

var w:int=0
var h:int=0


func setV(vec,val):
	vec.x=vec.x as int
	vec.y=vec.y as int
	
	var id=vec.x+(w*vec.y)
	if id>=arr.size():
		arr.resize(id+1)
		
	arr[id]=val
	
	
func getV(vec):
	vec.x=vec.x as int
	vec.y=vec.y as int
	
	var id=vec.x+(w*vec.y)
	if id<arr.size():
		return arr[id]
	
	pass
	
	
func _init(w,h):
	self.w=w
	self.h=h
	pass

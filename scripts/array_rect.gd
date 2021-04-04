class_name ArrayRect
extends Object

var arr:Array=[]

var w:int=0
var h:int=0


func setV(vec,val):
	if vec.x>-1 && vec.y>-1:
		vec.x=vec.x as int
		vec.y=vec.y as int
		
		var id=(vec.x+(w*vec.y)) as int
		if id>=arr.size():
			arr.resize(id+1)
			
		arr[id]=val
	
	
func getV(vec):
	if vec.x>-1 && vec.y>-1:
		vec.x=vec.x as int
		vec.y=vec.y as int
		
		var id=vec.x+(w*vec.y)
		id=id as int
		if id>-1 && id<arr.size():
			return arr[id]
	
	pass
	
	
func _init(w,h):
	self.w=w
	self.h=h
	pass

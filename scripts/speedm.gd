class_name SpeedM
extends Object


var maxSpeed
var speedUp
var speedDown
var thisSpeed

var move=false

var scale=1


func run(delta):
	
	if move:
		thisSpeed+=speedUp*delta*scale
		thisSpeed=min(thisSpeed,maxSpeed*scale*delta)
	else:
		thisSpeed-=speedDown*delta*scale*(0.06*scale)
		thisSpeed=max(0,thisSpeed)
	pass


func _init(maxSpeed,speedUp,speedDown,thisSpeed):
	self.maxSpeed=maxSpeed
	self.speedUp=speedUp
	self.speedDown=speedDown
	self.thisSpeed=thisSpeed
	pass

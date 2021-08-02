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


func _init(_maxSpeed, _speedUp, _speedDown, _thisSpeed):
	self.maxSpeed = _maxSpeed
	self.speedUp = _speedUp
	self.speedDown = _speedDown
	self.thisSpeed = _thisSpeed
	pass

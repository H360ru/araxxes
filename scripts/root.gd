extends Node

var game:Game

func _ready():
	randomize()
	game=Game.new(null,self)
	
	
	pass
	
func _input(event):
	game.input(event)


func _physics_process(delta):
	game.run(delta)

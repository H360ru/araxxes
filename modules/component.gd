extends Node
class_name Component
var discription: String

func _ready():
	Global.COMPONENTS[name] = self #[weakref(self)]

func _exit_tree():
	#TODO: обработка ошибок
	Global.COMPONENTS.erase(name)

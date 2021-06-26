extends Node

var GAME
#0 - харвестром, 1 - червяком
# var whoToPlay=0
# game.setting.speed=1+index

# class_name UnitMove
# extends Base

# #Вызываетсяпри начале движения
# signal onUnitMoveStart(unitMove)
# #Вызываетсяпри начале окончания движения
# signal onUnitMoveFinished(unitMove)
# #когда юнит останавливается
# signal onUnitMoveStop(unitMove)

onready var BACKGROUND = get_tree().get_root().get_node('Node2D/CanvasLayer/Background')
onready var SITE_LABEL = get_tree().get_root().get_node('Node2D/CanvasLayer/SiteLabel')

func open_menu():
	print('MENU!!!!')
	var node = get_tree().get_root().get_node('Node2D/CanvasLayer/Меню')._to_child_name('ИнгеймМеню')
	# print(node.name)
	# node.visible = !node.visible

func background_visible(_bool: bool):
	Kostil.BACKGROUND.visible = _bool
	Kostil.SITE_LABEL.visible = _bool

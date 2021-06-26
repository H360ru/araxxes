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

onready var SOUND = load('G:/Projects/Araxxes/scripts_new/sound_test/SoundManager.gd').new()

onready var BACKGROUND = get_tree().get_root().get_node('Node2D/CanvasLayer/Background')
onready var SITE_LABEL = get_tree().get_root().get_node('Node2D/CanvasLayer/SiteLabel')

func _ready():
	add_child(SOUND)
	yield(get_tree(), 'idle_frame')
	BACKGROUND = get_tree().get_root().get_node('Node2D/CanvasLayer/Background')
	SITE_LABEL = get_tree().get_root().get_node('Node2D/CanvasLayer/SiteLabel')

func open_menu():
	print('MENU!!!!')
	var node = get_tree().get_root().get_node('Node2D/CanvasLayer/Меню')._to_child_name('ИнгеймМеню')
	# print(node.name)
	# node.visible = !node.visible

#BUG: HTTML5 build
#At: res://scripts_new/kostil.gd:36:background_visible()
#Invalid set index 'visible' (on base: 'Nil') with value of type 'bool'. tmp_js_export.js:371:18
func background_visible(_bool: bool):
	Kostil.BACKGROUND.visible = _bool
	Kostil.SITE_LABEL.visible = _bool

extends Node

#HACK POOP везде костыли, не трогать, не дышать
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

var icon_dictionary: Dictionary = {
	"close": preload("res://textures/ui/close.png"),
	"end_tour": preload("res://textures/ui/end_tour.png"),
	"move": preload("res://textures/ui/move.png"),
#	"move2": preload("res://textures/ui/move2.png"),
	"attack": preload("res://textures/ui/attack.png"),
	"take": preload("res://textures/ui/take.png"),
	"safe": preload("res://textures/ui/safe.png"),
#	"empty": preload("res://textures/ui/empty.png"),
	"back": preload("res://textures/ui/back.png"),
}

var test_arr: Array = [
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	]
var font = preload('res://scripts_new/font_matrix.gd').new()
var _font = DynamicFont.new()

onready var SOUND = load('res://scripts_new/sound_test/SoundManager.gd').new()

onready var BACKGROUND = get_tree().get_root().get_node('Node2D/CanvasLayer/Background')
onready var SITE_LABEL = get_tree().get_root().get_node('Node2D/CanvasLayer/SiteLabel')

func _ready():
	_font.font_data = load('res://fonts/Ubuntu-B.ttf')
	
	add_child(SOUND)
	yield(get_tree(), 'idle_frame')
	BACKGROUND = get_tree().get_root().get_node('Node2D/CanvasLayer/Background')
	SITE_LABEL = get_tree().get_root().get_node('Node2D/CanvasLayer/SiteLabel')
	prints('BACKGROUND, SITE_LABEL:', BACKGROUND, SITE_LABEL)
	randomize()

func open_menu():
	var node = get_tree().get_root().get_node('Node2D/CanvasLayer/Меню')._to_child_name('ИнгеймМеню')
	# print(node.name)
	# node.visible = !node.visible

func open_tutorial():
	var node = get_tree().get_root().get_node('Node2D/CanvasLayer/Меню')._to_child_name('Туториал')

func game_end():
	var node = get_tree().get_root().get_node('Node2D/CanvasLayer/Меню')._to_child_name('КонецИгры')

#BUG: HTTML5 build
#At: res://scripts_new/kostil.gd:36:background_visible()
#Invalid set index 'visible' (on base: 'Nil') with value of type 'bool'. tmp_js_export.js:371:18
func background_visible(_bool: bool):
	BACKGROUND = get_tree().get_root().get_node('Node2D/CanvasLayer/Background')
	SITE_LABEL = get_tree().get_root().get_node('Node2D/CanvasLayer/SiteLabel')
	BACKGROUND.visible = _bool
	SITE_LABEL.visible = _bool

func mad_text_size_test():
	var _font = DynamicFont.new()
	_font.font_data = load('res://fonts/Ubuntu-B.ttf')
	for text in test_arr:
		var _d = {}
		for size in range(1, 60):
			_font.size = size
			_d[size] = _font.get_string_size(text)#_d[_font.get_string_size(text)] = size
			yield(get_tree(), "idle_frame")
		prints(text, _d)

func get_string_size(_txt, _size, _node):
	if !font.size_arr.has(_txt):#== '12324':
		#_node.get("custom_fonts/font").size = _size
		#return Kostil.GAME.getLabelSizeString(_node)
		return _font.get_string_size(_txt)
	if _size > 60:
		#_node.get("custom_fonts/font").size = _size
		#return Kostil.GAME.getLabelSizeString(_node)
		return _font.get_string_size(_txt)
	# HACK: костыль для уменьшения долбанутого шрифта очков
	if test_arr.has(_txt):
		return font.size_arr[_txt][_size-1]*1.5
	
	return font.size_arr[_txt][_size-1]



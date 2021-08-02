class_name MenuInMenu
extends Base

#Главный нод елемента меню
var node
var menu

#С какого меню открыто
var fromMenu

var rectPosDo

func onButtonClick(_button, _name):
	pass
	
func onChangeViewportSize():
	pass


func checkSize():
	var size=node.get_viewport().size
	node.rect_size.y=size.y
	
	if size.x<size.y:
		node.rect_size=size
	else:
		node.rect_size.x=size.x/3
	pass
	
#Открыто ли меню
func isOpen():
	return node.visible

func open():
	node.visible=true
	if rectPosDo!=null:
		
		if node.get("rect_position")!=null:
			node.rect_position=rectPosDo
			
		elif node.get("transform")!=null:
			node.transform.origin=rectPosDo
	pass
	
	
func close():
	node.visible=false
	if node.get("rect_position")!=null:
		rectPosDo=node.rect_position
		node.rect_position=Vector2(99999999,0)
	
	elif node.get("transform")!=null:
		rectPosDo=node.transform.origin
		node.transform.origin=Vector2(99999999,0)
	pass
	
	
func run(_delta):
	pass

func _init(game, _menu, _node).(game):
	self.node = _node
	self.menu = _menu
	
	
	pass


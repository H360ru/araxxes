class_name Menu
extends Base

var node
var texrect

#Установлены ли настройки
var settingSets=false

var isOpen=true

var menuSetting:MenuSetting

func onChangeViewportSize():
	
	checkSize()
	if menuSetting!=null:
		menuSetting.onChangeViewportSize()
		
	
	pass
	
	
func checkSize():
	var size=node.get_viewport().size
	texrect.rect_size=size
	
	var labSite=game.labs.getByName("site")
	if labSite!=null:
		labSite.rect_position=size-labSite.rect_size
	pass
	
func open():
	node.transform.origin=Vector2(0,0)
	isOpen=true
	pass
	
func close():
	node.transform.origin=Vector2(99999999,0)
	isOpen=false
	pass
	
#Установить настройки	
func setSetting():
	
	
	
	var but=game.butt.getByName("new_game")
	if but!=null:
		but.visible=false
	but=game.butt.getByName("setting")
	if but!=null:
		but.visible=false
	but=game.butt.getByName("exit")
	if but!=null:
		but.visible=false
		
	
	menuSetting.open()
	
	settingSets=true
		
	pass
	

func onButtonClick(button,name):
	if menuSetting!=null:
		menuSetting.onButtonClick(button,name)

func setMenu():
	
	
	var but=game.butt.getByName("new_game")
	if but!=null:
		but.visible=true
	but=game.butt.getByName("setting")
	if but!=null:
		but.visible=true
	but=game.butt.getByName("exit")
	if but!=null:
		but.visible=true
	
	
	menuSetting.close()
	
	settingSets=false
	
	pass


func run(delta):
	if menuSetting!=null:
		menuSetting.run(delta)
	pass
	
	
	
func input(e):
	
	return true
	
	pass



func _init(game,node).(game):
	
	
	self.node=node
	
	texrect=node.get_node("TextureRect")
	
	menuSetting=MenuSetting.new(game,self,node.get_node("setting"))
	
	pass
	
	


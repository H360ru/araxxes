class_name Menu
extends Base

var node
var texrect

#Установлены ли настройки


var isOpen=true

var menuSetting:MenuSetting
var menuMain:MenuMain
var menuGame:MenuGame


#Устанавливался ли когда либо размер
var setSize=false

#Меню главного меню
var menu_container
var menu_game;

#Текущее меню
var thisMenu


#Вернуть назад по меню
func back():
	if thisMenu!=null:
		setMenu(thisMenu.fromMenu)
		return true
	return false
	pass



#Открыть меню
func setMenu(menu):
	if menu!=null:
		if thisMenu!=null:
			thisMenu.close()
			menu.fromMenu=thisMenu
		
		thisMenu=menu
		menu.open()
	
	pass


func onChangeViewportSize():
	
	checkSize()
	
	if menuSetting!=null:
		menuSetting.onChangeViewportSize()
	if menuMain!=null:
		menuMain.onChangeViewportSize()	
	if menuGame!=null:
		menuGame.onChangeViewportSize()	

#	if thisMenu!=null:
#		thisMenu.onChangeViewportSize()
	pass
	
	
func checkSize():
	var size=node.get_viewport().size
	
	
	texrect.rect_size=size

	var labSite=game.labs.getByName("site")
	if labSite!=null:
		labSite.rect_position=size-labSite.rect_size
			
	
	setSize=true	
	pass
	
func open():
	node.transform.origin=Vector2(0,0)
	isOpen=true
	
	if thisMenu!=null:
		thisMenu.open()
		
	game.butt.visibleByName("tomenu",false)
	
	pass
	
func close():
	node.transform.origin=Vector2(99999999,0)
	isOpen=false
	
	if thisMenu!=null:
		thisMenu.close()
		
	game.butt.visibleByName("tomenu",true)
	
	pass
	


func onButtonClick(button,name):
	
#	if menuSetting!=null:
#		menuSetting.onButtonClick(button,name)
#	if menuMain!=null:
#		menuMain.onButtonClick(button,name)
#	if menuGame!=null:
#		menuGame.onButtonClick(button,name)
#
	if thisMenu!=null:
		thisMenu.onButtonClick(button,name)

func setMenuSetting():
	setMenu(menuSetting)
	
	pass

func setMenuMain():
	
	setMenu(menuMain)
	
	pass
	
func setMenuGame():
	setMenu(menuGame)
	

func run(delta):
#	if menuSetting!=null:
#		menuSetting.run(delta)
#	if menuMain!=null:
#		menuMain.run(delta)	
#	if menuGame!=null:
#		menuGame.run(delta)	

	if thisMenu!=null:
		thisMenu.run(delta)
	pass
	
	
	
func input(_e):
	
	return true
	
	pass



func _init(game, _node).(game):
	
	
	self.node = _node
	
	texrect = _node.get_node("TextureRect")
	menu_container = _node.find_node("menu_container")
	menu_game = _node.find_node("menu_game")
	
	
	menuSetting=MenuSetting.new(game,self, _node.get_node("setting"))
	menuMain=MenuMain.new(game,self,menu_container)
	menuGame=MenuGame.new(game,self,menu_game)
	
	setMenuMain()
	
	
	pass
	
	


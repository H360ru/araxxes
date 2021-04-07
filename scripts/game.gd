class_name Game
extends Base


var node
#карта игры
var map:MapGame

#последнй размер вюпорта
var lastSizeViewport=Vector2(0,0)

var viewportMap:Viewport
var map_view:TextureRect

#Меню юнита
var unUnitMenu:UiUnitMenu

#Игроки в игре
var players:Players
#Очередь ходов
var queue:Queue

var setting:Setting

var joy:Joystick
#кнопки
var butt:Buttons
#метки
var labs:Labels

var menu:Menu;


#0 - харвестром, 1 - червяком
var whoToPlay=0

var labelGameOvet


func _init(game,node).(game):
	game=self
	self.node=node
	
	
	setting=Setting.new(self)
	players=Players.new(self)
	
	joy=Joystick.new(self)
	
	
	queue=Queue.new(self)
	queue.connect("onQueueEndTour",self,"onQueueEndTour")
	queue.connect("onQueueChangePlayer",self,"onQueueChangePlayer")
	
	map_view=node.get_node("map_view")
	viewportMap=node.get_node("Viewport")
	
	unUnitMenu=UiUnitMenu.new(self,node.get_node("ui_unit_menu"))
	
	unUnitMenu.connect("onUiUnitMenuClick",self,"onUiUnitMenuClick")
	
	butt=Buttons.new(self)
	butt.connect("onButtonClick",self,"onButtonClick")
	
	labs=Labels.new(self)
	labs.connect("onLabelClick",self,"onLabelClick")
	
	map=MapGame.new(self,node.get_node("Viewport/map"))
	
	menu=Menu.new(self,node.get_node("main_menu"))
	
	
	
	labelGameOvet=node.get_node("gameover")
	
	#============
	calcNodes(node,"checkNode")
	
	#=============
	
	
	pass 
	


#начать новую игру
func newGame():
	
	
	
	players.clear()
	queue.clear()
	map.units.clear()
	
	
	#==============
	
	addPlayer(Player.TYPE_PLAYER,"player")
	addPlayer(Player.TYPE_CPU,"cpu")
	
	map.initMap()
	
	
	onQueueEndTour()
	onQueueChangePlayer(queue.getThisPlayer())



#Вызывается при окончании тура и начале следующего
func onQueueEndTour():
	
	#каждому игроку начисляется новые очки
	players.newTour();
	
	
	pass
	
#Вызывается при переходи хода к другому игроку
func onQueueChangePlayer(newPlayer):
	
	refreshPlayerLabel(newPlayer)
	
	var units=map.units.getUnitsPlayer(newPlayer,true,1)
	if units!=null && units.size()>0:
		map.cameraGame.setTarget(units[0].node)
	
	pass
	

#Обновить строку игрока
func refreshPlayerLabel(player):
	
	labs.setText("points","Очков: "+player.points as String)
	labs.setText("howturn","Ходит: "+player.name as String)
	labs.setText("spice","Спайса: "+player.spices as String)
	
	checkSizeUpLabels()
		

func onLabelClick(label,name):
	pass	

func onButtonClick(button,name):
	
	if name=="toharv":
		
		map.cameraToHarvestr()
	if name=="toworm":
		map.cameraToWorm()
		
	if name=="newgame":
		pass
	if name=="setting":
		menu.setSetting()
		pass
		
		
	if name=="newgameharw":
		whoToPlay=0
	if name=="newgameworm":
		whoToPlay=1
		
	if name=="newgameharw" || name=="newgameworm":
		#Новая игра
		newGame()
		menu.close()
		
	if name=="closeNotic":
		var labelN=labs.getByName("notic")
		labelN.visible=false
		
		
	if name=="exit":
		node.get_tree().set_auto_accept_quit(false)
		node.get_tree().quit()
		
		
		
		pass	
		
	if menu!=null:
		menu.onButtonClick(button,name)
		
		
	pass	
	
#Вызывается для каждого нода в начале
func checkNode(node):
	
	var theme=load("res://themes/ornate-theme/ornate-theme.tres")
	if node is Label || node is Button:
		node.theme=theme
		pass
	
	butt.checkButton(node)
	
	map.checkNodes(node)
	
	labs.checkLabel(node)
	
	pass	
	


#Добавить игрока
func addPlayer(type,name):
	
	var pl:Player=Player.new(self,type,name)
	players.addPlayer(pl)
	
	queue.addPlayer(pl)
	
	
	
	return pl;

#Вызываетс япри клике меню
func onUiUnitMenuClick(ui:UiUnitMenu,tile):
	
	var unit=ui.unit
	
	if tile.enabled:
		
		
		
		if tile.name==UI.NAME_TILE_CLOSE:
			ui.close()
		if tile.name==UI.NAME_TILE_END:
			ui.close()
			ui.unit.ended=true
			map.units.checkEndTurnByPlayer(ui.unit.player)
			
		if tile.name==UI.NAME_TILE_MOVE:
			
			unit.saveSave()
			
			#ui.unit.canMove=true
			ui.unit.selecTilesForMove()
			ui.close()
			
			
		if tile.name==UI.NAME_TILE_BACK:
			if ui.unit.states.issetSave():
				ui.unit.backState()
			ui.close()	
			map.manMap.clearSelect()
		
		if tile.name==UI.NAME_TILE_SAFE:
			if unit.isSafeSet():
				unit.safe()
			ui.close()	
		
		if tile.name==UI.NAME_TILE_TAKE:
			
			unit.saveSave()
			
			unit.takeSpace()
			ui.close()
		if tile.name==UI.NAME_TILE_ATTACK:
			
			ui.unit.selecTilesForAttack()
			ui.close()	
			
			
		ui.checkIconsMenuByUnit(ui.unit)
		
		

#Вызывается при смене размера вюпорта
func onChangeViewportSize():
	
	var vps=node.get_viewport()
	if map!=null:
		
		map_view.rect_size=vps.size
		viewportMap.size=vps.size
		
		map.onChangeViewportSize()
		
	if unUnitMenu!=null:
		unUnitMenu.onChangeViewportSize()
		
	if menu!=null:
		menu.onChangeViewportSize()	
		
	checkUIGame()
	pass


#Проверить елементы ui игры
func checkUIGame():
	
	var size=node.get_viewport().size
	var offsetScreen=size.x/20
	
	#=====Кнопки
	
	var but=butt.getByName("toharv")
	if but!=null:
		but.rect_position.x=size.x/20
		but.rect_position.y=size.y-(but.rect_size.y+(offsetScreen))
	
	but=butt.getByName("toworm")
	if but!=null:
		but.rect_position.x=size.x-(but.rect_size.x+(offsetScreen))
		but.rect_position.y=size.y-(but.rect_size.y+(offsetScreen))	
		
	#=====метки
	checkSizeUpLabels()
		
	pass
	
	
func checkSizeUpLabels():
	
	var size=node.get_viewport().size
	var offsetScreen=size.x/20
	
	var label=labs.getByName("points")
	if label!=null:
		label.rect_position.x=offsetScreen
		label.rect_position.y=offsetScreen
		
	label=labs.getByName("howturn")
	if label!=null:
		label.rect_position.x=size.x/2-(label.rect_size.x/2)
		label.rect_position.y=offsetScreen	
		
	label=labs.getByName("spice")
	if label!=null:
		label.rect_position.x=size.x-(label.rect_size.x+offsetScreen)
		label.rect_position.y=offsetScreen	
	
	label=labs.getByName("notic")
	if label!=null:
		label.rect_position=size/2-(label.rect_size/2)
		var but=butt.getByName("closeNotic")
		if but!=null:
			but.rect_position.x=label.rect_size.x
		
func checkNotic():
	
	var size=node.get_viewport().size
	var label=labs.getByName("notic")
	if label!=null:
		label.rect_position=size/2-(label.rect_size/2)
		
		
	pass	

func run(delta):
	
	
	
	#===========Проверка смены размера вюпорта
	var vps=node.get_viewport().size
	if lastSizeViewport!=vps:
		lastSizeViewport=vps
		onChangeViewportSize()
	
	
	if map!=null:
		map.run(delta);
	
	if unUnitMenu!=null:
		unUnitMenu.run(delta)
		
	if menu!=null:
		menu.run(delta)
	
	

func input(e):
	
	if joy!=null:
		joy.input(e)
	
	
	var nextInput=true
	
	#===============
	if menu!=null:
		nextInput=menu.input(e)
	
	if butt!=null && nextInput:
		nextInput=butt.input(e)
	
	if unUnitMenu!=null && nextInput:
		nextInput=unUnitMenu.input(e)	
	
	
	#================
	if map!=null && nextInput:
		nextInput=map.input(e)
		
	
	
	if e is InputEventKey:
		if e.pressed && e.scancode==KEY_ESCAPE:
			if menu.isOpen:
				if menu.settingSets:
					menu.setMenu()
				else:
					menu.close()
			else:
				menu.open()
				
				
			pass
		
	pass

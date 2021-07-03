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

#Провреено ли было меню ui
var checkedUi=false;

var multyTouch:MultyTouch

#Черная полоска сверзху
var colorRectUp
#Черная полоска снизу
var colorRectDown


func _init(game,node).(game):
	game=self
	Kostil.GAME = self
	self.node=node
	
	
	setting=Setting.new(self)
	setting.speed = Global.SETTINGS.game_speed

	players=Players.new(self)
	
	joy=Joystick.new(self)
	
	multyTouch=MultyTouch.new(self)
	
	queue=Queue.new(self)
	queue.connect("onQueueEndTour",self,"onQueueEndTour")
	queue.connect("onQueueChangePlayer",self,"onQueueChangePlayer")
	
	map_view=node.get_node("map_view")
	viewportMap=node.get_node("Viewport")
	
	colorRectUp=node.get_node("ColorRect_up")
	colorRectDown=node.get_node("ColorRect_down")
	
	# TODO BUG: виновник торжества
	unUnitMenu=UiUnitMenu.new(self,node.get_node("ui_unit_menu"))
	
	unUnitMenu.connect("onUiUnitMenuClick",self,"onUiUnitMenuClick")
	
	butt=Buttons.new(self)
	butt.connect("onButtonClick",self,"onButtonClick")
	
	labs=Labels.new(self)
	labs.connect("onLabelClick",self,"onLabelClick")
	
	map=MapGame.new(self,node.get_node("Viewport/map"))
	#Подключение мультитач событий
	multyTouch.connect("onMultyTouchStart",map,"onMultyTouchStart")
	multyTouch.connect("onMultyTouchFinish",map,"onMultyTouchFinish")
	multyTouch.connect("onMultyTouchRun",map,"onMultyTouchRun")
	
	menu=Menu.new(self,node.get_node("main_menu"))
	
	
	
	labelGameOvet=node.get_node("gameover")
	
	#============
	calcNodes(node,"checkNode")
	
	#=============
	
	# бесполезно, непредсказуемый код
	#  Kostil.get_tree().get_root().connect('size_changed', self, 'onChangeViewportSize')
	
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
	
	unUnitMenu.close()



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
	
	checkSizeUI()
		

func onLabelClick(label,name):
	
	if name.find("site")==0:
		OS.shell_open("https://example.com")
	
	pass	

func onButtonClick(button,name):
	
	
	#================Игра
	if menu.isOpen==false:
		if name=="toharv":
			map.cameraToHarvestr()
		if name=="toworm":
			map.cameraToWorm()
		if name=="closeNotic":
			var labelN=labs.getByName("notic")
			labelN.visible=false
		if name=="tomenu":
			menu.open()
			menu.setMenuGame()
			# print('MENU!!!!')
			Kostil.open_menu()
			pass
	#==================меню
	
		
	if menu!=null:
		menu.onButtonClick(button,name)
		
		
	pass	
	
#Вызывается для каждого нода в начале
func checkNode(node):
	
	var theme=getThemeOrnate()
	if node is Label || node is Button:
		node.theme=theme
		pass
	
	butt.checkButton(node)
	
	map.checkNodes(node)
	
	labs.checkLabel(node)
	
	pass	
	

func getThemeOrnate():
	var theme=load("res://themes/ornate-theme/ornate-theme.tres")
	return theme

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
			if ui.unit.isRunning()==false:
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
		
		#map_view.rect_position+=Vector2(200,200)
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
	
	
		
	#=====метки
	checkSizeUI()
		
	checkedUi=true	
	pass



func checkSizeUI():
	
	
	var size=node.get_viewport().size
	var offsetScreen=size.x/50
	
	
	
	var labelTurn=labs.getByName("howturn")
	var labelSpice=labs.getByName("spice")
	var buttHarw=butt.getByName("toharv")
	var buttWorm=butt.getByName("toworm")
	
	var buttmenu=butt.getByName("tomenu")
	var offsetScreenY=1#buttmenu.rect_size.y*1.1
	
	
	setFontSize(labelTurn,30)
	setFontSize(labelSpice,30)
	setFontSize(buttHarw,30)
	setFontSize(buttWorm,30)
	
	var c=0
	while true:
	
		
		var rectT=getRectControl(labelTurn)
		var rectS=getRectControl(labelSpice)
		var rectH=getRectControl(buttHarw)
		var rectW=getRectControl(buttWorm)	
		
		if labelTurn!=null:
			labelTurn.rect_position.x=size.x/2-(rectT.size.x/2)
			labelTurn.rect_position.y=offsetScreenY	
			
		
		if labelSpice!=null:
			labelSpice.rect_position.x=size.x-(rectS.size.x+offsetScreen)
			labelSpice.rect_position.y=offsetScreenY	
			
			
		
		if buttHarw!=null:
			buttHarw.rect_position.x=offsetScreen
			buttHarw.rect_position.y=size.y-(buttHarw.rect_size.y+(offsetScreenY))
		
		
		if buttWorm!=null:
			buttWorm.rect_position.x=size.x-(buttWorm.rect_size.x+(offsetScreen))
			buttWorm.rect_position.y=size.y-(buttWorm.rect_size.y+(offsetScreenY))	
			
			
		#====Провекра перекрытия
		
		if rectT.intersects(rectS):
			#Уменьшить размер шрифта
			
			minusFontSize(labelTurn)
			minusFontSize(labelSpice)
			
			
			
		if rectH.intersects(rectW):
			minusFontSize(buttHarw)
			minusFontSize(buttWorm)
			
			
			
		else:
			break
			
		c+=1
		if c>1000:
			break
	
#	
	checkNotic()
	
	
	buttmenu.rect_position.x=offsetScreen
	
	
	#========================Черные полоски
	colorRectUp.rect_size.x=size.x
	colorRectUp.rect_size.y=labelSpice.rect_position.y+labelSpice.rect_size.y
	
	colorRectDown.rect_size.x=size.x
	colorRectDown.rect_size.y=size.y-buttHarw.rect_position.y
	colorRectDown.rect_position.y=buttHarw.rect_position.y
	
	#=========================Размер карты
	map_view.rect_position.y=colorRectUp.rect_size.y
	map_view.rect_size.y=size.y-(colorRectUp.rect_size.y+colorRectDown.rect_size.y)
	
	viewportMap.size=map_view.rect_size
	

func getRectControl(label):
	if label!=null:
		var size=getLabelSizeString(label)
		var rect
		if size!=null:
			rect=Rect2(label.rect_position,size)
		return rect
	pass	
		
func checkNotic():
	
	var size=node.get_viewport().size
	var label=labs.getByName("notic")
	if label!=null:
		
		
		label.rect_size.x=size.x*0.6
		label.update()
		label.rect_position=size/2-(label.rect_size/2)
		var but=butt.getByName("closeNotic")
		if but!=null:
			but.rect_position.x=label.rect_size.x
		
		
	pass	

func run(delta):
	
	
	
	#===========Проверка смены размера вюпорта
	var vps=node.get_viewport().size
	if lastSizeViewport!=vps:
		lastSizeViewport = vps
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
	
	
	#===============UI
	if menu!=null:
		nextInput=menu.input(e)
	
	if butt!=null && nextInput:
		nextInput=butt.input(e)
	
	if labs!=null && nextInput:
		nextInput=labs.input(e)
	
	if unUnitMenu!=null && nextInput:
		nextInput=unUnitMenu.input(e)	
	
	
	#================
	if multyTouch!=null && nextInput:
		nextInput=multyTouch.input(e)
	
	#================карта
	if map!=null && nextInput:
		if multyTouch.isMult==false:
			nextInput=map.input(e)
	
	
	#=================KEY_ESCAPE
	if e is InputEventKey:
		if e.pressed && e.scancode==KEY_ESCAPE:
			if menu.isOpen:
				if menu.thisMenu!=null && menu.thisMenu!=menu.menuGame:
					var isBack=menu.back()
					if isBack==false:
						#назад не вышло
						if menu.thisMenu==menu.menuGame:
							menu.close()
				else:
					menu.close()
			else:
				menu.open()
				menu.setMenuGame()
				
				
			pass
	
		
	pass
	

func debug(text):
	labs.getByName("debug").text=text
	pass
func debugA(text):
	labs.getByName("debug").text+="\r\n"+text
	pass

# TODO BUG: 93!!! вызова minusFontSize
#Установить максимальный размер контролу с текстом. кнопки метки и тд.
func setMaxSize(node,startSizeFont,maxSize:Vector2):
	set_max_size_new(node,startSizeFont, maxSize)
#	if node!=null && node.text != '':
##		print('setMaxSize CALL!!!')
##		if node.text == '':
##			print('NULL NODE TEXT!!!')
#		var c=0
#		setFontSize(node,startSizeFont)
#		var back=false
#		while true:
#			var thisSize=getLabelSizeString(node)
#			if back==false:
#				if thisSize.x>maxSize.x || thisSize.y>maxSize.y:
#					minusFontSize(node)
#				else:
#					back=true
#			else:
#
#				if thisSize.x<maxSize.x && thisSize.y<maxSize.y:
#					plusFontSize(node)
#				else:
#					minusFontSize(node)
#					break
#			c+=1
#			if c>startSizeFont*2:
#				break
#			pass
#	pass

# POOP: 
# наговнокодил дихотомический поиск вместо линейного

func set_max_size_new(node,startSizeFont: int, maxSize:Vector2):
#	prints('FONT', node.get("custom_fonts/font").font_data.font_path)
#	return
	if node!=null && node.text != '':
		var _font: Font = node.get("custom_fonts/font");
#		if _font == null: return
		var _txt: String = node.text
		
		var _font_size: int = startSizeFont*2
		_font.size = startSizeFont*2
		if maxSize.x > Kostil.get_string_size(_txt, startSizeFont*2, node).x:
			node.get("custom_fonts/font").size = startSizeFont-15
#			node.set("custom_fonts/font", _font)
			return
		
		_font_size = startSizeFont
		while maxSize.x < Kostil.get_string_size(_txt, _font_size, node).x:
			_font_size /= 2
			if _font_size < 1:
				_font_size = 1
				break
		startSizeFont = _font_size
		
		var endSizeFont: int
		while maxSize.x > Kostil.get_string_size(_txt, _font_size, node).x:
			_font_size *= 2
		endSizeFont = _font_size
		
		var midpoint: int# = floor((endSizeFont + startSizeFont)/2)
		
		
		_font_size = startSizeFont
		var back = false
		
		var c=0
		while true:
			midpoint = floor((endSizeFont + startSizeFont)/2)
			
			_font_size = midpoint
			var thisSize = Kostil.get_string_size(_txt, midpoint, node)
			
			if thisSize.x>maxSize.x || thisSize.y>maxSize.y:
				endSizeFont = midpoint
			elif thisSize.x<maxSize.x && thisSize.y<maxSize.y:
				startSizeFont = midpoint
			c+=1
			if (endSizeFont - startSizeFont) < 2:#c>startSizeFont*2:
				break
			pass
#		node.set("custom_fonts/font", _font)
		node.get("custom_fonts/font").size = _font_size
		prints('!!!set_max_size!!!', c, startSizeFont, endSizeFont, _font_size, node)
	pass


# TODO BUG подозрительном много вызовов 151!
#Вернуть размер строки в метке
func getLabelSizeString(node):
	var font:Font=node.get("custom_fonts/font");
	if font!=null:
		return font.get_string_size(node.text)
			
func setFontSize(node,size):
	var font:Font=node.get("custom_fonts/font");
	if font!=null:
		font.size=size
		node.set("custom_fonts/font",font);	
		
func getFontSize(node):
	var font:Font=node.get("custom_fonts/font");
	if font!=null:
		return font.size

# TODO BUG: вызывает лагспайк на 6.8ms 93!!! вызова
func minusFontSize(node):
	prints(node, 'getFontSize CALL!!!')
	var font:Font=node.get("custom_fonts/font");
	if font!=null && font.size>0:
		font.size-=1
		node.set("custom_fonts/font",font);	
		
func plusFontSize(node):
	var font:Font=node.get("custom_fonts/font");
	if font!=null && font.size>0:
		font.size+=1
		node.set("custom_fonts/font",font);		
		
func setTextColor(node,color):
	var font=node.get("custom_fonts/font");
	if color!=null:
		font.outline_color=color
		node.set("custom_fonts/font",font);
	
	node.set("custom_colors/font_color",color)
	
	

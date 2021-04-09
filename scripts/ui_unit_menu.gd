
class_name UiUnitMenu
extends Base

#Вызывается при клике по хексагону
signal onUiUnitMenuClick(uiMenu,tile)


#Нод меню где 7 хексогонов
var node
var tiles:Array=[]

#позиция центра меню
var pos:Vector2=Vector2(0,0)
#последняя позици при установке плиток
var lastPosSet;

#Размер квадрата плитки меню
var sizeTile=0;

var startTile:Vector2=Vector2(-1,0)

var timeChangeVisible=0
#За скольок открывать всё меню
var timeOpened=200
#Открывается ли меню
var open=false


#Для какого югита меню
var unit:Unit


#Смена вюпорта
func onChangeViewportSize():
	.onChangeViewportSize()
	
	
	checkSize()
	
	checkPosition()
	
	pass



#Заполнить меню для юнита
func fillmenuByUnit(unit):
	
	
	self.unit=unit
	
	#=======заполнение для всех
	
	tiles[1].setIcon(UI.NAME_TILE_END)
	tiles[2].setIcon(UI.NAME_TILE_MOVE)
	tiles[3].setIcon(UI.NAME_TILE_BACK)
	
	#============
	if unit.name=="harvestr":
		tiles[4].setIcon(UI.NAME_TILE_TAKE)
		tiles[5].setIcon(UI.NAME_TILE_SAFE)
		
	
	
	if unit.name=="worm":
		tiles[4].setIcon(UI.NAME_TILE_ATTACK)
		tiles[5].setIcon(UI.NAME_TILE_EMPTY)
			
		
		
	#========================Включение выключение кнопок
	checkIconsMenuByUnit(unit)
			
		
	pass
	
	
#Проверит ьелемнты меню для юнита. если нужно включить выключить и тд.
func checkIconsMenuByUnit(unit):
	
	
	
	#===========Когда двигается
	if unit.isRunning():
		enableByName(UI.NAME_TILE_END,false)
		enableByName(UI.NAME_TILE_MOVE,false)
		enableByName(UI.NAME_TILE_BACK,false)
		
	else:
		enableByName(UI.NAME_TILE_END,true)
		enableByName(UI.NAME_TILE_MOVE,true)
		
		#=======Вернуться назад
		enableByName(UI.NAME_TILE_BACK,unit.states.issetSave())
		
		#=======Защита
		enableByName(UI.NAME_TILE_SAFE,unit.isSafeSet())
		
		#======Плитка для взятия
		var settileTak=false
		if unit.isTakeSpace():
			settileTak=true
		
		enableByName(UI.NAME_TILE_TAKE,settileTak)	
		
		#=======Атака
		enableByName(UI.NAME_TILE_ATTACK,unit.player.points>=unit.pointAttack)	
	
	#===========когда выключены все иконки
	if game.queue.isThisPlayPlayer(unit.player)==false:
		var i=0;
		for tile in tiles:
			if i>0:
				tile.enable(false)
			i+=1
	
	
	
	pass
	
#Включить или отключить иконку по имени
func enableByName(name,enable):
	for tile in tiles:
		if tile.name==name:
			tile.enable(enable)
			break
	pass


func run(delta):
	
	
	
	checkSize()
	
	for tile in tiles:
		tile.run(delta)
	
	
	if lastPosSet!=pos:
		checkPosition()
		lastPosSet=pos
		
	
	setPositionTiles()
	
	
	
	#открытие закрытие меню
	if timeChangeVisible!=0:
		var i=0;
		for tile in tiles:
			if i>0:
				
				var op=i as float/tiles.size() as float
				var op2=(OS.get_system_time_msecs()-timeChangeVisible) as float/timeOpened as float
				
				if open:
					
					if op<op2:
						tile.open()
				
				else:
					if op<op2:
						tile.close()
			else:
				#для первой плитки в центре
				if open:
					tile.open()
				else:
					var isCLosed=true
					var i2=0
					var maxTime=0
					for tch in tiles:
						if i2!=0:
							if tch.open:
								isCLosed=false
							
							maxTime=max(tch.timeColse,maxTime)	
						i2+=1
					
					var diff=OS.get_system_time_msecs()-maxTime
					
					if isCLosed && diff>timeOpened as float/tiles.size() as float:
						tile.close()
			i+=1
			
	if unit!=null:
		pos=unit.getPosInScreen()
		pass
	
	pass
	
#Установить нужную позицию для плиток меню
func setPositionTiles():
	
	var i=0
	var centerTile=tiles[0]
	var vecOffset:Vector2=startTile
	for tile in tiles:
		if i>0:
			tile.node.rect_position=centerTile.node.rect_position+(vecOffset*sizeTile*1.0*tile.openCoeff)
			vecOffset=vecOffset.rotated(PI/3)
			
		i+=1
	pass	
	
#Установка нужной позиции
func checkPosition():
	
	#==========Что бы меню не выходило за пределы камеры
	
	var vs=node.get_viewport().size
	
	pos.x=max(sizeTile,pos.x)
	pos.y=max(sizeTile,pos.y)
	
	pos.x=min(vs.x-(sizeTile*2),pos.x)
	pos.y=min(vs.y-(sizeTile*2),pos.y)
	
	
	
	#========Устнаовка позиции
	var i=0
	while true:
		tiles[i].node.rect_position=pos
		
		i+=1
		if i==tiles.size():
			break;
	pass
	
	
	
	
func checkSize():
	
	var size=node.get_viewport().size
	sizeTile=sqrt((size.x*size.x)+(size.y*size.y))/30;
	
	
	for tile in tiles:
		tile.setSize(Vector2(sizeTile,sizeTile))
		
	pass
	
func open():
	
	timeChangeVisible=OS.get_system_time_msecs()
	open=true
	
	
	pass
	
func close():
	timeChangeVisible=OS.get_system_time_msecs()
	open=false
	
	pass



func input(e):
	
	if e is InputEventMouseButton:
		var even:InputEventMouseButton=e
		if open:
			if even.pressed:
				var pos2d=game.map.checkEventPosition(even)
				if pos2d!=null:
					for tile in tiles:
						
						var rect=tile.node.get_rect()
						if rect.has_point(pos2d):
							
							emit_signal("onUiUnitMenuClick",self,tile)
							return false
	return true
	
	
	pass

func _init(game,node).(game):
	
	self.node=node
	
	#====Плитки для меню
	var i=0
	while true:
		var tile=UiTile.new(game,node.get_node("tile"+i as String))
		tile.tileId=i
		if i>0:
			tile.setTileTexture(i)
		tiles.push_back(tile)
		
		i+=1
		if i==7:
			break;
	
	pass


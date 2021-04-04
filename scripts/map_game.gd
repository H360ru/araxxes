
#в сцене должен быть нод car
class_name MapGame
extends Base


#Нод карты
var node
#камера 2d
var camera


#Размеры 
var di:Dimension=Dimension.new()

var units:Units;
#Для управления камерой
var cameraGame:CameraGame;

#менеджер карты
var manMap:ManagerMap

#Последний клику мыши
var lastMouseClick:Vector2;

#Слой для юнитов
var unitsNode;

var cpu:CPU;


func _init(game,node).(game):
	self.node=node
	
	
	unitsNode=node.get_node("units")
	
	camera=node.get_node("Camera2D")
	
	cameraGame=CameraGame.new(game,camera);
	
	manMap=ManagerMap.new(game,node,cameraGame)
	manMap.generateMap()
	
	units=Units.new(game)
	
	
	units.connect("onClickUnit",self,"onClickUnit")
	
	cpu=CPU.new(game)
	
	
	#calcNodes(node,"checkNodes")
	
	cameraGame.connect("onCameraGameClickMap",units,"onClickMap")
	
	
	
	pass
	
	
#Камеру на харвестра
func cameraToHarvestr():
	var harv=units.getByName("harvestr")
	if harv!=null:
		cameraGame.setTarget(harv.node)
	
#камеру на червя	
func cameraToWorm():
	var un=units.getByName("worm")
	if un!=null:
		cameraGame.setTarget(un.node)
	


#Окончатьлная натсрой игнры
func initMap():
	
	
	manMap.clearSelect()
	
	#=======Выставить рандомно игроков
	
	
	var playHwo=["player","cpu"]
	
	var harv=addUnit(Vector2(5,5),"harvestr",game.players.getPlayerByName(playHwo[(game.whoToPlay%2)]))
	var worm=addUnit(Vector2(6,5),"worm",game.players.getPlayerByName(playHwo[(game.whoToPlay+1)%2]))
	
	
	#=====Устнаовка накарту
	
	setInRandomPos(harv)
	setInRandomPos(worm)
	
	
	
	cameraGame.setTarget(harv.node)
	
	
	pass	
	

#Установить юнита в рандомное место
func setInRandomPos(unit):
	if unit!=null:
		var pos=ransomPosMap()
		
		var tile=manMap.getRandomNotBlockTile(pos,unit)
		unit.setInTile(tile.x,tile.y)
	
#получить случайную клетку н карте
func ransomPosMap():
	return Vector2(3+((randf()*(manMap.mapWidth-6)) as int),3+((randf()*(manMap.mapHeight-6)) as int))

#Открыть меню для юнита
func openMenuForUnit(unit:Unit):
	if unit!=null:
		var um:UiUnitMenu=game.unUnitMenu;
		if um!=null:
			
			um.pos=unit.getPosInScreen()
			um.pos-=Vector2(um.sizeTile/2,um.sizeTile/2)
			
			um.fillmenuByUnit(unit)
			
			um.open()
	pass




#Вызываетсяпри клике по юниту
func onClickUnit(units,unit,sceenPos):
	
	if self.units==units:
		if unit!=null:
			var thisPlayer=game.queue.getThisPlayer()
			
			#====меню для игркоа за этим компом
			if thisPlayer!=null && thisPlayer.type==Player.TYPE_PLAYER && unit.player==thisPlayer:
				
				openMenuForUnit(unit)
				
	pass	
	
	
#Добавить юнита на карту
func addUnit(tileid,name,forPlayer):
	if manMap!=null:
		var unitNode=load("res://scenes/unit_"+name as String+".tscn").instance()
		
		unitsNode.add_child(unitNode)
		var unitSprite=unitNode.get_child(0)
		
		
		
		var unit=units.addUnit(unitSprite,name)
		
		unit.player=forPlayer
		
		unit.setInTile(tileid.x,tileid.y)
		
		units.onUnitMoveStop(unit)
		
		return unit
	
	pass
	
#проверка всех нодов	
func checkNodes(node):
	if units!=null:
		units.checkNode(node)
		
	
	pass


func onChangeViewportSize():
	.onChangeViewportSize()
	
	pass

func run(delta):
	.run(delta)
	
	
	var vp=camera.get_viewport().size
	
	if cameraGame!=null:
	
		cameraGame.run(delta)
		
	if units!=null:
	
		units.run(delta)
		
	if cpu!=null:
		cpu.run(delta)
		
		
	


func checkEventPosition(e):
	if e is InputEventMouse || e is InputEventMouseButton || e is InputEventMouseMotion:
		var addX=0
		var addY=0
		if OS.window_fullscreen:
			addX=OS.window_position.x
			addY=OS.window_position.y
		
		var x=e.position.x+addX;#когда не корректо включается полноекранный режим
		var y=e.position.y+addY;
		
		return Vector2(x,y)
   

func input(e):
	
	
	if e is InputEventKey:
		if e.pressed && e.scancode==KEY_V:
			pass
		
		
	if e is InputEventMouseButton:
		if e.button_index==BUTTON_LEFT && e.pressed:
			lastMouseClick=checkEventPosition(e)
	
	var nextEvent=true
	
	if cameraGame!=null:
		nextEvent=cameraGame.input(e)
	
	if units!=null && nextEvent:
		units.input(e);
	
	
	return nextEvent
	
	pass

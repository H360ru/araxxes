class_name CameraGame
extends Base

#Вызывается при клике оп миру, кординаты
signal onCameraGameClickMap(point2d);

const SPEED_CAM=10000

var nodeCamera2d;

#Цель для камеры
var nodeTarget;
#за скольок камера перемещается  содной целши на другую
var timeChangetarget=1000

#Время начала смены цели для камеры
var timeStartChangeTarget=0;


var speedCam:Array=[]
var keyMove:Array=[Joystick.KEY_LEFT,Joystick.KEY_UP,Joystick.KEY_RIGHT,Joystick.KEY_DOWN]
var vecDirect:Array=[Vector2(-1.0,0.0),Vector2(0.0,-1.0),Vector2(1.0,0.0),Vector2(0.0,1.0)]

#Лимит для передвиженя камеры
var limit:Rect2

#направлться ли не цель, если нажать передвижения камеры, то на цель двигаться не будет
var moveToTarget=true

var zoomMax=Vector2(40,40)
var zoomMin=Vector2(8,8)
var zoomTarget


#Вернуть позицую камеры
func getPosCam():
	return nodeCamera2d.transform.origin
	
#Вернуть прямоугольник камеры
func getRectCam():
	
	var size=getCameraSize()
	
	var pos=getPosCam()-(size/2)
	return Rect2(pos,size)
	
	pass

func run(delta):
	
	
	
	#================Двидение камеры
	var movevec=Vector2(0,0)
	var i=0
	for spc in speedCam:
		spc.run(delta)
		movevec+=vecDirect[i]*spc.thisSpeed*SPEED_CAM
		i+=1
		
	nodeCamera2d.transform.origin+=movevec
	if movevec.x!=0 || movevec.y!=0:
		moveToTarget=false
	
	
	if moveToTarget:
		#=====================проверка смены цел для камеры
		if nodeTarget!=null:
			
			if timeStartChangeTarget>0:
				
				#====перемещение к целии
				var timeChanged=OS.get_system_time_msecs()-timeStartChangeTarget
				var vecToTarget=nodeTarget.transform.origin-nodeCamera2d.transform.origin
				var lenv=vecToTarget.length()
				
				vecToTarget=vecToTarget.normalized()
				nodeCamera2d.transform.origin+=vecToTarget*(lenv/10.0)
				
				
				pass
		
	#==============Ограничения для камеры
	if limit!=null:
		var checkRect=limit
		checkRect.position+=getCameraSize()/2
		checkRect.size-=getCameraSize()
		
		
		var posc=nodeCamera2d.transform.origin
		
		posc.x=min(posc.x,checkRect.position.x+checkRect.size.x)
		posc.x=max(posc.x,checkRect.position.x)
		posc.y=min(posc.y,checkRect.position.y+checkRect.size.y)
		posc.y=max(posc.y,checkRect.position.y)
		
		nodeCamera2d.transform.origin=posc
		
	#================Зуммирование
	
	if zoomTarget!=null:
		nodeCamera2d.zoom+=(zoomTarget-nodeCamera2d.zoom)/10
		
	pass
	
	
#Вернуть координаті с экрана на карте
func getCooInMap(cooScreen:Vector2):
	if cooScreen!=null:
		var sizeC2=getCameraSize()/2
		return cooScreen-sizeC2
		
#Установить цель для камеры
func setTarget(node):
	self.nodeTarget=node
	timeStartChangeTarget=OS.get_system_time_msecs();
	moveToTarget=true
	
	
	
	pass

func addZoom():
	zoomTarget=nodeCamera2d.zoom+Vector2(3,3)
	zoomTarget.x=min(zoomMax.x,zoomTarget.x)
	zoomTarget.y=min(zoomMax.y,zoomTarget.y)
	pass
	
func removeZoom():
	zoomTarget=nodeCamera2d.zoom-Vector2(3,3)
	zoomTarget.x=max(zoomMin.x,zoomTarget.x)
	zoomTarget.y=max(zoomMin.y,zoomTarget.y)
	pass

func getCameraSize():
	var vps=nodeCamera2d.get_viewport().size;
	return vps*nodeCamera2d.zoom
	pass

func input(e):
	if e is InputEventMouseButton:
		if e.button_index==BUTTON_LEFT && e.pressed:
			var mouseClick=game.map.checkEventPosition(e)
			
			
			var vps=nodeCamera2d.get_viewport().size;
			
			var vecToPointScreen=mouseClick-(vps/2)
			vecToPointScreen*=nodeCamera2d.zoom
			
			var clickInMap:Vector2=nodeCamera2d.transform.origin+vecToPointScreen
			
			emit_signal("onCameraGameClickMap",clickInMap)
			return false
		if e.button_index==BUTTON_WHEEL_DOWN && e.pressed:
			addZoom()
			pass
		if e.button_index==BUTTON_WHEEL_UP && e.pressed:
			removeZoom()
			
			pass
	return true
			
	


#Вызывается при нажатии на определенную клавишу
func onJoystickKey(key,down):
	
	#=====провекра двидения камеры
	var i=0
	for keysCheck in keyMove:
		if keysCheck==key:
			speedCam[i].move=down
			
		i+=1
		
	pass

func _init(game,nodeCamera2d).(game):
	self.nodeCamera2d=nodeCamera2d
	
	var c=0
	while true:
		speedCam.push_back(SpeedM.new(1.0,0.5,0.5,0.0))
		c+=1
		if c==keyMove.size():
			break;
	
	
	if game.joy!=null:
		if game.joy.is_connected("onJoystickKey",self,"onJoystickKey")==false:
			game.joy.connect("onJoystickKey",self,"onJoystickKey")
	
	pass

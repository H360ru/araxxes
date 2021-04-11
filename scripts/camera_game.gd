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

var zoomMax=Vector2(70,70)
var zoomMin=Vector2(2,2)
var zoomTarget

#Зум при начале зуммирования пальцами
var zooStartTouch

#позиция камеры при начале перемещения
var cameraStartMoveTouch
#Последняя позиция камеры установлена в ручную
var lastPosCamSetHand

#Сейчас перемещение ли вручную
var isMovingHand=false
#Можно ли перемещать камеруц пальцем
var canMoveCameraTouch=true
#Позиция клика мыши по нажатии
var clickMousePos
#Последний веткор перемещения каемры свайпом или мышей
var lastVecHand
#Для проверки чегото раз в сек
var chec1s=0
#Юнит для которого проверять зум
var unitCheckZoom

#Установить камеру на кооррдинаты
func setPosCam(pos):
	nodeCamera2d.transform.origin=pos
	
	checkLimit()
	
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
	
	
	if moveToTarget && isMovingHand==false:
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
	checkLimit()
		
	#================Зуммирование
	
	if zoomTarget!=null:
		nodeCamera2d.zoom+=(zoomTarget-nodeCamera2d.zoom)/10.0
		
		
	#=============
	
	if game.multyTouch.touchs.size()==0:
		canMoveCameraTouch=true
		isMovingHand=false
		#Остаточное передвижение
		if game.multyTouch.timeTouch!=null && game.multyTouch.timeTouch>100:
			if lastVecHand!=null:
				lastVecHand*=0.9
				setPosCam(getPosCam()+lastVecHand)
	else:
		lastVecHand=null
		
	#========Что то делать раз в сек. 
	if OS.get_system_time_msecs()/1000%2==chec1s:	
		chec1s+=1
		chec1s%=2
		
		unitCheckZoom=game.map.units.getUnitByMinDist(getPosCam())
		
		checkZoomMInMax()
		
		
		
	pass
	
func checkLimit():
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
	pass
	
	
#Вернуть координаты с экрана на карте
func getCooInMap(cooScreen:Vector2):
	if cooScreen!=null:
		var sizeC2=getCameraSize()/2
		return cooScreen-sizeC2
		
#Установить цель для камеры
func setTarget(node):
	self.nodeTarget=node
	timeStartChangeTarget=OS.get_system_time_msecs();
	moveToTarget=true
	unitCheckZoom=null
	

func onMultyTouchStart():
	if game.multyTouch.isMult:
		zooStartTouch=nodeCamera2d.zoom
	
	pass
	
	
func onMultyTouchFinish(removed):
	
	if game.multyTouch.touchs.size()==0:
		if removed:
			if cameraStartMoveTouch!=null && lastPosCamSetHand!=null:
				setPosCam(lastPosCamSetHand)
				
			isMovingHand=false
			cameraStartMoveTouch=null
			#moveToTarget=false
	
	
		
	pass
	
func onMultyTouchRun():
	
	if game.multyTouch.isMult:
		
		canMoveCameraTouch=false
		#=======Зуммирование камеры
		var coeff=game.multyTouch.getCoeffDistTouch()
		zoomTarget=zooStartTouch*coeff
		checkZoomMInMax()
		
	else:
		#======передвижение камеры
		
		if game.multyTouch.touchs.size()==1:
			if canMoveCameraTouch:
				
				moveToTarget=false
				isMovingHand=true
				if cameraStartMoveTouch==null:
					cameraStartMoveTouch=getPosCam()
					
				var tou:Touch=game.multyTouch.touchs[0]
				var vecMove=tou.thisT-tou.startT
				vecMove*=nodeCamera2d.zoom
				
				var newPos=cameraStartMoveTouch-vecMove
				if lastPosCamSetHand!=null:
					lastVecHand=newPos-lastPosCamSetHand
					
				lastPosCamSetHand=newPos
				setPosCam(lastPosCamSetHand)
		else:
			
			canMoveCameraTouch=true	
		
	
	pass
	

#Установкить зум
#percent 0 - 1
func setZoom(percent):
	zoomTarget=zoomMin+((zoomMax-zoomMin)*percent)
	pass

func addZoom():
	zoomTarget=nodeCamera2d.zoom+Vector2(3,3)
	checkZoomMInMax()
	pass
	
func removeZoom():
	zoomTarget=nodeCamera2d.zoom-Vector2(3,3)
	checkZoomMInMax()
	pass


func onChangeViewportSize():
	checkZoomMInMax()
	pass
	
	

func checkZoomMInMax():
	
	
	#=======корректирвака зума по юниту
	
	var minZoom=zoomMin
	var unit
	if unitCheckZoom!=null:
		unit=unitCheckZoom
	else:
		unit=game.map.units.getUnitByNode(nodeTarget)
		
		
	if unit!=null:
		var camSize=nodeCamera2d.get_viewport().size
		
		if camSize.x>camSize.y:
			#Горизонтальная ориентация
			minZoom.y=(unit.node.get_rect().size.y*unit.node.transform.get_scale().y)/(camSize.y)
			minZoom.x=minZoom.y
			

		if camSize.x<camSize.y:
			#Веритикальная ориентация
			minZoom.x=(unit.node.get_rect().size.x*unit.node.transform.get_scale().x)/(camSize.x)
			minZoom.y=minZoom.x
			
		zoomMin=minZoom
		pass
	
	if zoomTarget!=null:
		zoomTarget.x=max(zoomMin.x,zoomTarget.x)
		zoomTarget.y=max(zoomMin.y,zoomTarget.y)
	
	

func getCameraSize():
	var vps=nodeCamera2d.get_viewport().size;
	return vps*nodeCamera2d.zoom
	pass


#Вернуть кооринаты с экрана на карте
func getPosMapFromDisplay(posDisplay):
	var vps=nodeCamera2d.get_viewport().size;
	var vecToClick=posDisplay-(game.map_view.rect_position+(game.map_view.rect_size/2))
	var scaleCam=vecToClick/(game.map_view.rect_size/2)
	var clickInMap=nodeCamera2d.transform.origin+(((vps/2)*nodeCamera2d.zoom)*scaleCam)

	return clickInMap
	

#Вернуть позицию с карты на экране
func getPosDisplayFromMap(posMap):
	
	var vps=nodeCamera2d.get_viewport().size;
	var vecToPos=posMap-nodeCamera2d.transform.origin#(game.map_view.rect_position+(game.map_view.rect_size/2))
	var vecCam=((vps/2)*nodeCamera2d.zoom)
	var scale=vecToPos/vecCam
	var centerView=(game.map_view.rect_position+(game.map_view.rect_size/2))
	var posDisplay=centerView+((game.map_view.rect_size/2)*scale)

	return posDisplay

func input(e):
	if e is InputEventMouseButton:
		if e.button_index==BUTTON_LEFT:
			if e.pressed:
				clickMousePos=game.map.checkEventPosition(e)
				
			if e.pressed:
				var mouseClick=game.map.checkEventPosition(e)
				if clickMousePos!=null && mouseClick!=null:
					if (clickMousePos-mouseClick).length()<10:
						
						var vps=nodeCamera2d.get_viewport().size;
						
						var clickInMap=getPosMapFromDisplay(clickMousePos)
						
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

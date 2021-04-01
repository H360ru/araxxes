class_name UiTile
extends Base




#Нод тайла меню. Внутри значек меню
var node
#Значек меню
var icon
#Включен ли елемент меню
var enabled=true
#на скольок открыта плитка
var openCoeff=0;
var open=false
#Время, когда было полное закрытие. При открытии время ставится на 0
var timeColse=0
var openCoeffSeTime=1
#Ид тайла
var tileId=0;
#9Максимальбна прозрачнось плитки
var alpha=1;
#Название иконки UI...
var name


#Установить иконку name - имя иконки в каталоге testures/ui/
func setIcon(name):
	self.name=name
	icon.texture=load("res://textures/ui/"+name+".png")
	
	
	if name==UI.NAME_TILE_EMPTY:
		icon.texture=null
		enable(false)
	
	pass


#Включить или выключить кнопку меню
func enable(enabled):
	self.enabled=enabled
	if enabled:
		alpha=1.0
	else:
		alpha=0.5
	
	pass

func open():
	timeColse=0
	openCoeffSeTime=1
	open=true

func close():
	open=false
	pass



func run(delta):
	
	if open:
		openCoeff+=(1.0-openCoeff)/3.0
	else:
		openCoeff+=(0.0-openCoeff)/3.0
	
	
	node.modulate.a=alpha*openCoeff
	node.rect_scale=Vector2(1,1)*openCoeff
	
	if abs(openCoeff)<0.01 && abs(openCoeffSeTime)>0.01:
		timeColse=OS.get_system_time_msecs()
		openCoeffSeTime=openCoeff
	
	pass
	
#текстуры с идами в textures/ui/tile+id+.png	
func setTileTexture(id):
	var tex=load("res://textures/ui/tile"+id as String+".png")
	
	node.texture=tex
	pass

func setSize(size:Vector2):
	
	node.rect_size=size
	icon.rect_size=size
	
	node.rect_pivot_offset=size/2
	icon.rect_pivot_offset=size/2
	
	
	pass

func _init(game,node).(game):
	self.node=node
	
	icon=node.get_node("icon")
	
	
	
	
	setIcon("close")
	pass



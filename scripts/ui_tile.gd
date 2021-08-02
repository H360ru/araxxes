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
#Метка текста поверх плитки
var text
#последний установленный размер
var lastSize
#Текст для показа очков
var points
#тмаленький текст под основным
var smallText
#Чем больше тем медленнее открывает
var coeffOpenSpeed=2.0

func setPoints(_points):
	self.points.text = _points
	if lastSize!=null:
		setSize(lastSize)
	pass

#Добавить тмаленький текст под основным
func setSmallText(_text):
	if smallText==null:
		smallText=self.text.duplicate()
		smallText.text=_text
		self.text.get_parent().add_child(smallText)
		refreshThemeAndFont(smallText)
		
		setSize(lastSize)
	pass

#Убрать маленький текст
func clearSmallText():
	if smallText!=null:
		var par=smallText.get_parent()
		if par!=null:
			par.remove_child(smallText)
	
	smallText=null
	


func setTile(_name):
	node.texture=load("res://textures/ui/"+_name+".png")
	
	pass

func checkFontColorPoints():
	if node.texture!=null:
		
		var image=node.texture.get_data()
		image.lock()
		var color=image.get_pixel(image.get_width()/2,image.get_height()/2)
		image.unlock()
		game.setTextColor(points,color)
		
	pass

#Установить иконку name - имя иконки в каталоге testures/ui/
func setIcon(_name):
	self.name = _name
	if _name != UI.NAME_TILE_POINTS:
		icon.texture=Kostil.icon_dictionary[_name]#load("res://textures/ui/"+name+".png")
	
	
	if _name==UI.NAME_TILE_EMPTY:
		icon.texture=null
		enable(false)
	
	
	clearSmallText()
	
	#=======надписи согласно иконке
	if _name==UI.NAME_TILE_ATTACK:
		setText("Атака")
	if _name==UI.NAME_TILE_BACK:
		setText("Отмена")
	if _name==UI.NAME_TILE_CLOSE:
		setText("Закрыть")
	if _name==UI.NAME_TILE_EMPTY:
		setText("")
	if _name==UI.NAME_TILE_END:
		setText("конец")
		setSmallText("хода")
	if _name==UI.NAME_TILE_MOVE:
		setText("Движение")
	if _name==UI.NAME_TILE_SAFE:
		setText("Защита")	
	if _name==UI.NAME_TILE_TAKE:
		setText("Взять")
		setSmallText("Спайс")	
	if _name==UI.NAME_TILE_POINTS:
		setText("Очков")	
		setSmallText("Действия")
	pass

func setText(_text):
	self.text.text = _text
	
	if lastSize!=null:
		setSize(lastSize)
	
	pass

#Включить или выключить кнопку меню
func enable(_enabled):
	self.enabled = _enabled
	if _enabled:
		alpha=1.0
	else:
		alpha=0.5
	
	pass

# warning-ignore:function_conflicts_variable
func open():
	timeColse=0
	openCoeffSeTime=1
	open=true

func close():
	open=false
	pass



func run(_delta):
	
	if open:
		openCoeff+=(1.0-openCoeff)/coeffOpenSpeed
	else:
		openCoeff+=(0.0-openCoeff)/coeffOpenSpeed
	
	
	node.modulate.a=alpha*openCoeff
	node.rect_scale=Vector2(1.0,1.0)*openCoeff
	
	if abs(openCoeff)<0.01 && abs(openCoeffSeTime)>0.01:
		timeColse=OS.get_system_time_msecs()
		openCoeffSeTime=openCoeff
	
	
	
	pass
	
#текстуры с идами в textures/ui/tile+id+.png	
func setTileTexture(id):
	var tex=load("res://textures/ui/tile"+id as String+".png")
	
	node.texture=tex
	
	checkFontColorPoints()
	
	
	pass


func setMinSize(_node):
	_node.rect_min_size = _node.rect_size

# TODO BUG: лакспайк на 13.6 ms 6 вызовов
#разместить текстовый нод посредине плитки по ширине, и после posY, с максимальнім размером maxSize
func setNodeAfterPosY(_node,posY,startFontSize,maxSize):
	
	game.setMaxSize(_node,startFontSize,maxSize)
	var sizeLabel=game.getLabelSizeString(_node)
	if sizeLabel!=null:
		_node.rect_size=sizeLabel
		
		_node.rect_position=(lastSize/2)-(_node.rect_size/2)
		_node.rect_position.y=posY

# TODO BUG: вызывает лагспайк на 8.5ms 3 вызова
func setSize(size:Vector2):
	
	lastSize=size
	
	
	var sizePoints=size*0.2
	
	node.rect_size=size
	node.rect_pivot_offset=size/2
	
	#======Иконка
	
	
	if name==UI.NAME_TILE_ATTACK:
		#Другтй размер для плитки атаки
		var sizeAttackIcon=(size-sizePoints)*0.7
		var center=(size-sizePoints)/2
		
		icon.rect_size=sizeAttackIcon
		icon.rect_position.y=center.y-(sizeAttackIcon.y/2)
		
	elif name==UI.NAME_TILE_BACK:
		var sizeMoveIcon=(size*0.7)
		var center=(size-sizePoints)/2
		
		icon.rect_size=sizeMoveIcon
		icon.rect_position.y=center.y-(sizeMoveIcon.y/2)
		
	else:
		
		icon.rect_size=size*0.4
		icon.rect_position.y=(size.y/3.5)-(icon.rect_size.y/2)
		
	icon.rect_position.x=(size.x/2)-(icon.rect_size.x/2)
		
	
	
	#=======Видимость
	
	icon.visible=true
	points.visible=true
	
	#===иконки
	if name==UI.NAME_TILE_POINTS || name==UI.NAME_TILE_CLOSE:
		icon.visible=false
	
	#==очки	
	if name==UI.NAME_TILE_BACK || name==UI.NAME_TILE_CLOSE || name==UI.NAME_TILE_END:	
		points.visible=false
	
	
	#==============Текст
	
	
	var maxSizetext
	if name==UI.NAME_TILE_ATTACK:
		#Отдельно натсрой катекста с этим меню
		maxSizetext=Vector2(icon.rect_size.x*0.7,icon.rect_size.y*0.2)
		
		setNodeAfterPosY(text,(icon.rect_position.y+icon.rect_size.y)-maxSizetext.y,30,maxSizetext)	
		
	elif name==UI.NAME_TILE_BACK:
		#Отдельно натсрой катекста с этим меню
		maxSizetext=Vector2(icon.rect_size.x*0.7,icon.rect_size.y*0.2)
		
		setNodeAfterPosY(text,(icon.rect_position.y+(icon.rect_size.y*1.05))-maxSizetext.y,30,maxSizetext)	
		
	else:
		
		var maxSizeY=size.y/5
		
		if name==UI.NAME_TILE_END || name==UI.NAME_TILE_POINTS:
			maxSizeY=size.y*0.3
		
		if smallText!=null:
			maxSizeY*=0.6
			
		maxSizetext=Vector2(size.x*0.7,maxSizeY)
		setNodeAfterPosY(text,size.y/2,30,maxSizetext)	
	
	#===========маленький текст
	if smallText!=null:
		
		var fs=game.getFontSize(text)
		setNodeAfterPosY(smallText,size.y/2+maxSizetext.y,fs,maxSizetext/2)	
		#HACK:
#		return #<===
		pass
		
	#==============Очки
	if name!=UI.NAME_TILE_POINTS:
		
		game.setMaxSize(points,30,sizePoints)
		var sizeLabel=game.getLabelSizeString(points)
		if sizeLabel!=null:
			
			var sizeR=max(sizeLabel.x,sizeLabel.y)
			points.rect_size=Vector2(sizeR,sizeR)
			
			points.rect_position=(size/2)-(points.rect_size/2)
			points.rect_position.y+=(size.y/2)-(points.rect_size.y)
			
			
	else:
		
		game.setMaxSize(points,50,size*0.4)
		var sizeLabel=game.getLabelSizeString(points)
		if sizeLabel!=null:
			
			var sizeR=max(sizeLabel.x,sizeLabel.y)
			points.rect_size=Vector2(sizeR,sizeR)
			
			points.rect_position=(size/2)-(points.rect_size/2)
			points.rect_position.y=(size.y/4)-(points.rect_size.y/2)
	
	pass


func refreshThemeAndFont(_node):
	_node.theme = game.getThemeOrnate()
	var font:Font = _node.get("custom_fonts/font");
	if font != null:
		font = font.duplicate()
		_node.set("custom_fonts/font",font);	
	pass

func _init(game, _node).(game):
	self.node = _node
	
	icon = _node.find_node("icon")
	text = _node.find_node("text")
	points = _node.find_node("points")
	
	
	text.uppercase=true
	
	refreshThemeAndFont(text)
	refreshThemeAndFont(points)	
	
	#HACK: 
	setIcon("close")
	
	checkFontColorPoints()
	
	pass



class_name MenuSetting
extends MenuInMenu


#выбор скорости
var option_speed:OptionButton
#Фон
var bg
var alpha=0
#настройки
var box
#Кнопка назад
var button_settingback


var setSize=false


func onButtonClick(button,name):
	
	if isOpen():
		if name=="tomenu":
			menu.back()
		pass
	pass

func onChangeViewportSize():
	checkSize()

func checkSize():
	
	var size=node.get_viewport().size
	bg.rect_size=size
	
	box.rect_position=size/2-(box.rect_size/2)
	
	button_settingback.rect_position.x=size.x-(button_settingback.rect_size.x*1.2)
	button_settingback.rect_position.y=button_settingback.rect_size.y*0.2
		
	setSize=true
	
#Открыто ли меню
func isOpen():
	return node.visible

func open():
	.open()
	
	option_speed.select(game.setting.speed-1)
	
	pass
	
func close():
	.close()
	pass
	
	
func run(delta):
	var targ=0
	if node.visible:
		targ=1
	
	#node.modulate.a=(1-alpha)/20
	#alpha=node.modulate.a


func onItemSelectedSpeed(index):
	game.setting.speed=1+index
	pass

func _init(game,menu,node).(game,menu,node):
	
	
	option_speed=node.find_node("OptionSpeed")
	
	option_speed.add_item("speed x1")
	option_speed.add_item("speed x2")
	option_speed.add_item("speed x3")
	option_speed.add_item("speed x4")
	option_speed.add_item("speed x5")
	option_speed.add_item("speed x6")
	
	option_speed.connect("item_selected",self,"onItemSelectedSpeed")
	
	bg=node.find_node("bg")
	box=node.find_node("box")
	button_settingback=node.find_node("button_settingback")
	
	checkSize()
	
	pass

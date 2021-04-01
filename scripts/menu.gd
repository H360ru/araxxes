class_name Menu
extends Base

var node
var option_speed;
var texrect

#Включено ли меню
var settedmenu=false

var isOpen=true

func onChangeViewportSize():
	
	texrect.rect_size=node.get_viewport().size
	
	
	pass
	
func open():
	node.transform.origin=Vector2(0,0)
	isOpen=true
	pass
	
func close():
	node.transform.origin=Vector2(99999999,0)
	isOpen=false
	pass
	
func setOption():
	
	var but=game.butt.getByName("new_game")
	if but!=null:
		but.visible=false
	but=game.butt.getByName("setting")
	if but!=null:
		but.visible=false
	but=game.butt.getByName("exit")
	if but!=null:
		but.visible=false
		
	if option_speed!=null:
		option_speed.visible=true
		
		
	settedmenu=true
		
	pass
	

	
func setMenu():
	
	
	var but=game.butt.getByName("new_game")
	if but!=null:
		but.visible=true
	but=game.butt.getByName("setting")
	if but!=null:
		but.visible=true
	but=game.butt.getByName("exit")
	if but!=null:
		but.visible=true
		
	if option_speed!=null:
		option_speed.visible=true
	
	
	settedmenu=false
	
	pass


func run(delta):
	pass
	
	
	
func input(e):
	
	return true
	
	pass


func onItemSelectedSpeed(index):
	game.setting.speed=1+index
	pass

func _init(game,node).(game):
	
	
	self.node=node
	option_speed=node.get_node("option_speed")
	
	option_speed.connect("item_selected",self,"onItemSelectedSpeed")
	
	option_speed.add_item("speed x1")
	option_speed.add_item("speed x2")
	option_speed.add_item("speed x3")
	option_speed.add_item("speed x4")
	option_speed.add_item("speed x5")
	option_speed.add_item("speed x6")
	
	texrect=node.get_node("TextureRect")
	pass
	
	


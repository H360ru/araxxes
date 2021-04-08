class_name MenuMain
extends MenuInMenu



func onButtonClick(button,name):
	
	if isOpen():
		
		if name=="setting":
			menu.setMenuSetting()
			
		if name=="newgameharw":
			game.whoToPlay=0
		if name=="newgameworm":
			game.whoToPlay=1
			
		if name=="newgameharw" || name=="newgameworm":
			#Новая игра
			game.newGame()
			menu.close()
		
		if name=="exit":
			node.get_tree().set_auto_accept_quit(false)
			node.get_tree().quit()
	pass

func onChangeViewportSize():
	checkSize()
	pass


func checkSize():
	
	var size=node.get_viewport().size
	node.rect_size.y=size.y
	
	if size.x<size.y:
		node.rect_size.x=size.x
	else:
		node.rect_size.x=size.x/3
	
#Открыто ли меню
func isOpen():
	return node.visible


func open():
	.open()
	
	
	pass
	
func close():
	.close()
	pass
	
	
func run(delta):
	pass



func _init(game,menu,node).(game,menu,node):
	
	
	
	pass

class_name MenuGame
extends MenuInMenu



func onButtonClick(button,name):
	if isOpen():
		
		if name=="gameResume":
			menu.close()
		if name=="gameSetting":
			menu.setMenuSetting()
		if name=="gameExit":
			menu.setMenuMain()
		pass
	
	
	pass

func onChangeViewportSize():
	checkSize()
	pass


func checkSize():
	
	var size=node.get_viewport().size
	node.rect_size.y=size.y
	
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
	
	self.menu=menu
	
	
	pass

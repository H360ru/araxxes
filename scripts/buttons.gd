class_name Buttons
extends Base

signal onButtonClick(button,name)

var buttons:Array=[]


func visibleByName(name,visible):
	var b=getByName(name)
	if b!=null:
		b.visible=visible

#Вернуть кнопку оп имени
func getByName(name):
	for b in buttons:
		if b!=null:
			if b.name.find("button_"+name)==0:
				return b
	pass
	
	

#Проверить нод на кнопку, и добавить до кнопок
func checkButton(node):
	if node.name.find("button")==0 && node is Button:
		
		buttons.push_back(node)
	pass


func input(e):
	
	
	if e is InputEventScreenTouch || e is InputEventScreenDrag:
		var pos2d=game.map.checkEventPosition(e)
		for bun in buttons:
			if bun!=null:
				var rect=bun.get_global_rect()
				if rect!=null:
					if rect.has_point(pos2d):
						return false
	
	if e is InputEventMouseButton:
		if e.button_index==BUTTON_LEFT && e.pressed:
			var pos2d=game.map.checkEventPosition(e)
			for bun in buttons:
				if bun.get_global_rect().has_point(pos2d):
					var name=bun.name.split("_")[1]
					emit_signal("onButtonClick",bun,name)
					return false
	return true
	
	pass	

func _init(game).(game):
	pass

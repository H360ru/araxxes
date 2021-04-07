class_name Labels
extends Base

signal onLabelClick(label,name)

var labels:Array=[]


#Вернуть по имени
func getByName(name):
	for b in labels:
		if b!=null:
			if b.name.find("label_"+name)==0:
				return b
	pass

#Установит текст в метку по имени
func setText(name,text):
	for lab in labels:
		if lab.name.find("label_"+name)==0:
			lab.text=text

#Проверить нод на кнопку, и добавить до кнопок
func checkLabel(node):
	if node.name.find("label_")==0 && node is Label:
		labels.push_back(node)
	pass


func input(e):
	
	if e is InputEventMouseButton:
		if e.button_index==BUTTON_LEFT && e.pressed:
			var pos2d=game.map.checkEventPosition(e)
			for lab in labels:
				if lab.get_global_rect().has_point(pos2d):
					var name=lab.name.split("_")[1]
					emit_signal("onLabelClick",lab,name)
					return false
	return true
	
	pass	

func _init(game).(game):
	pass

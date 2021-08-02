
#Базовый клсс для всех классов
class_name Base
extends Object


#для прохода всех нодов
signal onNode(node)

var game

#Вызывается при смене вюпорта
func onChangeViewportSize():
	pass


func run(_delta):
	pass

func _init(_game):
	self.game = _game
	
	
#node - начальный нод, funcCallback имя функции с параметром нода
func calcNodes(node,funcCallback):
	
	if self.is_connected("onNode", self, funcCallback)==false:
# warning-ignore:return_value_discarded
		self.connect("onNode", self, funcCallback)
	
#	var startNode=node;
	var thist=node;
	
#	var count:int=0;
	var back=false;
	
	while true:
#		count+=1;
		
		var ch=thist.get_children();
		var continuew=false;
		if !back:
			for child in ch:
				
				emit_signal("onNode",child)
				#funcCallback(child);
					
					
				#проходим джальше в нутрь
				thist=child;
				continuew=true;
				break
					
			if continuew==true:
				continue;
		
			
		#нету детей
		
		var parent=thist.get_parent();
		
		
		if parent!=null && thist!=node:
			var childrenBack=parent.get_children();
			var selectNext=false;#выбрать следующй текущим
			if childrenBack.empty()==false:
#				var lastynode;
				for chb in childrenBack:
#					lastynode=chb;
					if chb==thist:
						selectNext=true;
					else:
						if selectNext:
							#выбираем текущий сейчас
							
							#funcCallback(chb);
							
							emit_signal("onNode",chb)
							
							
							
							thist=chb;
							continuew=true;
							back=false;
							break;
				if continuew==true:
					continue;
				
				back=true;
				thist=parent;
				
			else:
				break;
		else:
			break
		
	self.disconnect("onNode", self, funcCallback)

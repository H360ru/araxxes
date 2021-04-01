#Сессия игры
class_name Queue
extends Base


#Вызывается при окончании тура
signal onQueueEndTour()
#Вызывается при смене игрока
signal onQueueChangePlayer(newPlayer)

#Очередь игроков, в массиве обьъекты Player
var queue:Array=[]
#Чей ход
var thisQ=0;



func clear():
	queue=[]
	thisQ=0
	
	pass


#Какой сейчас играет игрок
func getThisPlayer():
	if queue!=null && queue.size()>0:
		if thisQ>-1 && thisQ<queue.size():
			return queue[thisQ]



#Играет ли сейчас передаваемый плеер
func isThisPlayPlayer(player):
	return player!=null && getThisPlayer()==player
		
	pass

#передать ход след. игроку
func nextPlayer():
	thisQ+=1
	if thisQ>=queue.size():
		thisQ=0;
		emit_signal("onQueueEndTour")
	emit_signal("onQueueChangePlayer",getThisPlayer())
	pass

#Добавить игрока для игры
func addPlayer(player:Player):
	queue.push_back(player)
	
	
	pass




func _init(game).(game):
	
	
	
	pass

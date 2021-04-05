
#Клас для управления игрокаи
class_name Players
extends Base


const NEW_POINTS_MAX=7
const NEW_POINTS_MIN=3

#Игроки, которые играю вместе
var players:Array=[]



func clear():
	players=[]
	pass

#Вызвать при начале нового тура
func newTour():
	
	
	for pl in players:
		
		#==Новые сочки
		pl.points=NEW_POINTS_MIN+((randf()*NEW_POINTS_MAX) as int)
		
		
		#==Юниты должны ходить заново
		game.map.units.refreshEndedBYPlayer(pl)
	
	pass


#Вернуть игрока по имени
func getPlayerByName(name):
	for pl in players:
		if pl.name==name:
			return pl
	pass

func addPlayer(player):
	players.push_back(player)
	pass

func _init(game).(game):
	pass

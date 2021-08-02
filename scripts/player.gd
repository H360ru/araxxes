
class_name Player
extends Base



#Тип плеера Игрок
const TYPE_PLAYER=1
#Тип плеера комп. 
const TYPE_CPU=2
#Игрок в сети
const TYPE_NETWORK=3
#тип игрока
var type

#Сколько очков в игрока
var points=0

#Имя игрока, должно быть уникальным среди всех игроков
var name=""

#Скольок собрано спайса
var spices=0 setget set_spices

func set_spices(value):
	spices = value
	if name == "player" && spices >= 5:
		#print('WIN!!!!!!!')
		# Kostil.GAME.labelGameOvet.visible=true
		Kostil.game_end()

#Отнять баллы
func minusPoints(pointsMinus):
	points-=pointsMinus
	points=max(0,points)
	
	pass


func _init(game, _type, _name).(game):
	self.type = _type
	self.name = _name
	
	pass


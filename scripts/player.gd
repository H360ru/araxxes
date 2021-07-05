
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
	if spices >= 5:
		print('WIN!!!!!!!')
		Kostil.GAME.labelGameOvet.visible=true

#Отнять баллы
func minusPoints(pointsMinus):
	points-=pointsMinus
	points=max(0,points)
	
	pass


func _init(game,type,name).(game):
	self.type=type
	self.name=name
	
	pass


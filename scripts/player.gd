
class_name Player
extends Base


#Ничего особненого
const ACTION_DEF=1;
#Выбор клетки для хода
const ACTION_SELECT_TILE=2;

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

#Что сейчас делает игрок
var action=ACTION_DEF
#Скольок собрано спайса
var spices=0



#Отнять баллы
func minusPoints(pointsMinus):
	points-=pointsMinus
	points=max(0,points)
	
	pass


func _init(game,type,name).(game):
	self.type=type
	self.name=name
	
	pass


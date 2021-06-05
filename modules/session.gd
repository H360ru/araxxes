extends Node

# TODO: #21 Класс игровой сессии. Инициализирует всю геймплейную логику
#  навигацию, ии, валидацию данных пользователя (античит)
#  не занимается графическим представлением данных

var win_conditions
var players: Dictionary
var spectators: Dictionary

func _turn():
	for player in players:
		#player.your_turn()
		yield(player, 'finished_turn')
	
	if win_conditions:
		return
	pass

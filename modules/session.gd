extends Node

# TODO: #21 Класс игровой сессии. Инициализирует всю геймплейную логику
#  навигацию, ии, валидацию данных пользователя (античит)
#  не занимается графическим представлением данных

class_name Session

var win_conditions
var players: Dictionary
var spectators: Dictionary

func _init(_players_arr):
	players = _players_arr
	Console.write_line('Session start!!!!')


func _turn():
	while true:
		for player in players:
			#player.your_turn()
			yield(player, 'finished_turn')
		
		if win_conditions:
			return
		pass

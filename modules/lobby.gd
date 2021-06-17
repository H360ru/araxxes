extends Node

# TODO: #20 Класс лобби отвечает за подтверждение/выполнения условий
#  проведения конкретной игровой сессиии и ее экземплирование
#  (и возможно подключение пиров, чат)
class_name Lobby

signal lobby_change

var start_conditions = 2
var players: Dictionary
var session: Session

func _init():
	connect('lobby_change', self, '_on_lobby_change')
	pass

func add_player(_user_id, _login):
	players[_user_id] = _login
	emit_signal('lobby_change')
	pass

func get_player(_user_id):
	return players[_user_id]
	
func remove_player(_user_id):
	emit_signal('lobby_change')
	return players.erase(_user_id)

func _start_session():
	session = Session.new(players)

func _on_lobby_change():
	if players.size() >= start_conditions:
		_start_session()
	pass





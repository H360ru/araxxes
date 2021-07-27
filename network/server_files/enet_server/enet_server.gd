extends Node

# TODO: #19 Серверный модуль
#  Пока простейшая демка чата в консоли
var login_name = 'default_nick'
onready var _client = ClientData.new(OS.get_cmdline_args()[0] if OS.get_cmdline_args().size() else 'admin',\
'admin_password')#.new('admin', 'admin_password')
var server_mode = 1

var network: NetworkedMultiplayerPeer
var port = 1929
var max_peers = 100

const DATA_BASE: Dictionary = {
	'admin': 'admin_password',
	'player1': 'player1_password',
	'player2': 'player2_password',
	'player3': 'player3_password',
}

signal Data

class ClientData:
	extends Resource
#	var login: String
#	var password: String
	var data: Dictionary = {
	'login': 'admin',
	'password': 'admin_password',
}

	func _init(_login = null, _password = null):
		data['login'] = _login
		data['password'] = _password

		#DEBUG HACK:
		if !(_login or _password):
			printerr('ClientData null instantiation!!!')

#func _ready():
##	if server_mode:
##		create_server()
#	Console.write_line("Server node added")
#	pass

# TODO Протестировать возможность RPC вызова на различных для клиент/сервера нодах

# TODO: #39 добавить поддержку WebRTCMultiplayer для браузера
# вместо NetworkedMultiplayerENet
func create_multiplayer_peer(_mode = 0):
	network = NetworkedMultiplayerENet.new()
	Console.write_line('ENet: '+str(network))
	
	#TODO: #26 доделать реакции на нетворк ивенты
	# warning-ignore:return_value_discarded
	network.connect("connection_succeeded", self, "_on_peer_event")
	# warning-ignore:return_value_discarded
	network.connect("connection_failed", self, "_on_peer_event")
	
	get_tree().multiplayer.connect('network_peer_packet', self, '_on_packet')
	
	# warning-ignore:return_value_discarded
	network.connect("peer_connected", self, "_on_client_connected")
	# warning-ignore:return_value_discarded
	network.connect("peer_disconnected", self, "_on_client_disconnected")
	pass

func _on_connection_established( protocol: String ):
	Console.write_line('webconnection_established '+protocol)
	
func _on_connection_error():
	Console.write_line('webconnection_error')

func _on_connection_closed( was_clean_close: bool ):
	Console.write_line('webconnection_closed '+str(was_clean_close))

func _on_packet(_one, _two):
	# if dict2inst(_two) is Lobby:
	#if _one is
	Console.write_line('packet ' + str(_one) + ' ' + str(bytes2var(_two)))

func _on_peer_event(id = null):
	Console.write_line(str(network.get_packet_peer()) + ' connection_status: '\
	 + str(network.get_connection_status()))

# TODO: разделить на отдельные объекты
func create_server(_cli: bool = true):
	create_multiplayer_peer(1)
	#network.allow_object_decoding = true
	
	var check
	check = network.create_server(port, max_peers)
		
	Global.get_tree().set_network_peer(network)
	if check == OK:
		set_meta('lobby', Lobby.new())
		Console.write_line("Server started")
	else:
		Console.write_line("Server creation error: "+str(check))
		assert(false)
		#TODO: при ошибке 20 и тесте в локальной сети сделать переход на
		# новый незанятый порт
		return
	
#	prints(_client.login)

func _on_client_connected(_user_id):
	Console.write("client_connected: "+str(_user_id))
	# TODO: написать библиотеку rpc запросов с асинхронным ожиданием и сигналом
	#HACK:
	rpc_id(_user_id,'_request_data','_client')
	var _client_data
	# NetRequest
	while true:
		var check = yield(self, "Data")
		if check[0] == _user_id:
			_client_data = check[1]
			break
	if _is_client_valid(_client_data):
		rpc_id(_user_id,'_print_message', 'true login/password', 'Server')
	else:
		#_disconnect_client(_user_id)
		pass
	get_meta('lobby').add_player(_user_id, _client_data['login'])#players[_user_id] = _client_data['login']#'name_'+str(_user_id)
	Console.write(" as " + get_meta('lobby').players[_user_id] + '\n')
#	if !has_meta('players'):
#		set_meta('players', {})
#	get_meta('players')[_user_id] = 'name_'+str(_user_id)
	pass

func _on_client_disconnected(_user_id):
	Console.write_line("client_disconnected"+str(_user_id))
	get_meta('lobby').remove_player(_user_id)
	pass

remote func _receive_message(_text):#, _login_name):
	var _login_name = get_meta('lobby').players[get_tree().get_rpc_sender_id()]
	rpc('_print_message', _text, _login_name)
#	Console.write_line("New_massege: " + _text)

func _is_client_valid(_client_data: Dictionary) -> bool:
	if DATA_BASE.has(_client_data['login']):
		if DATA_BASE[_client_data['login']] == _client_data['password']:
			return true
	return false

func _disconnect_client(_user_id):
	rpc_id(_user_id,'_print_message', 'wrong login/password', 'Server')
	yield(get_tree().create_timer(2), "timeout")
	network.disconnect_peer(_user_id, true)


func _push_message(_text):
	rpc_id(1, '_receive_message', _text)#, login_name)

remotesync func _print_message(_text, _login_name):
	Console.write_line(_login_name+": "+ _text)

remote func _request_data(_data_request: String):
#	var dcr = {}
	var _data = to_json(get(_data_request).data)
	var _user_id = network.get_unique_id()
	rpc_id(1, '_receive_data', _user_id, _data)#str(_data.login+' '+_data.password))
#	pass
	
remote func _receive_data(_user_id, _data):
#	validate_json(
	emit_signal("Data", _user_id, parse_json(_data))
#	return

func allow_new_connections(_allow: bool):
	Global.get_tree().refuse_new_network_connections = !_allow


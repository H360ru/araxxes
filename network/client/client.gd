extends Node

var login_name = 'default_nick'
onready var _client = ClientData.new(OS.get_cmdline_args()[0] if OS.get_cmdline_args().size() else 'admin',\
'admin_password')#.new('admin', 'admin_password')
var server_mode = 1

var network: NetworkedMultiplayerPeer
var port = 1929
var max_peers = 100

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

func _ready():
	create_client()

# TODO Протестировать возможность RPC вызова на различных для клиент/сервера нодах

# TODO: #39 добавить поддержку WebRTCMultiplayer для браузера
# вместо NetworkedMultiplayerENet
func create_multiplayer_peer(_mode = 0):
	
	network = NetworkedMultiplayerENet.new()
	
	#TODO: #26 доделать реакции на нетворк ивенты
	# warning-ignore:return_value_discarded
	network.connect("connection_succeeded", self, "_on_peer_event")
	# warning-ignore:return_value_discarded
	network.connect("connection_failed", self, "_on_peer_event")
	
	get_tree().multiplayer.connect('network_peer_packet', self, '_on_packet')
	
	network.connect("server_disconnected", self, "_on_peer_event")
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

func create_client(_cli: bool = true):

	create_multiplayer_peer()
	#network.allow_object_decoding = true
	
	var _ip = '127.0.0.1'
	var _port = port # 1909
	var check # = network.create_client(_ip, _port)
	check = network.create_client(_ip, _port)
	
	Global.get_tree().set_network_peer(network)
	if check == OK:
		Console.write_line("Welcome to chat!")
	else:
		Console.write_line("Connection error: "+ check)
		return

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


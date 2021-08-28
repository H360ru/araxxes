extends Component

class_name NetworkClient
var login_name = 'default_nick'
onready var _client = ClientData.new(OS.get_cmdline_args()[0] if OS.get_cmdline_args().size() else 'admin',\
'admin_password')#.new('admin', 'admin_password')

var network: NetworkedMultiplayerPeer
var port: int = 1920
var max_peers = 100

signal connection_resoult

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

func _init():
	discription = 'WebSocket клиент Версия 0.1'

func _ready():
	create_client()

# TODO: #39 добавить поддержку WebRTCMultiplayer для браузера
# вместо NetworkedMultiplayerENet
func create_multiplayer_peer(_mode = 0):
	network = WebSocketClient.new();
	Console.write_line('html: '+str(network))
	network.connect("connection_established", self, "_on_connection_established")
	network.connect("connection_error", self, "_on_connection_error")
	network.connect("connection_closed", self, "_on_connection_closed")
	
	#TODO: #26 доделать реакции на нетворк ивенты
	# warning-ignore:return_value_discarded
	network.connect("connection_succeeded", self, "_on_peer_event")
	# warning-ignore:return_value_discarded
	network.connect("connection_failed", self, "_on_peer_event")
	
	get_tree().multiplayer.connect('network_peer_packet', Network.MESSAGE_AGENT, '_on_packet')
	
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
	emit_signal('connection_resoult')

func create_client(_cli: bool = true):

	create_multiplayer_peer()
	network.allow_object_decoding = true
	
	var _ip = '127.0.0.1'
	var _port = port # 1909
	var check # = network.create_client(_ip, _port)

	var _socket_adress = "ws://"+_ip+":"+str(port)
	check = network.connect_to_url(_socket_adress, PoolStringArray(), true);
	#yield(self, 'connection_resoult')
	
	Global.get_tree().set_network_peer(network)
	#BUG: нерабочая проверка
	if check == OK:#network.get_connection_status() == 2:#
		Console.write_line("Connection succeeded")
	else:
		Console.write_line("Connection error: "+ check)
		return

func connect_to_ip():
	var _ip = '127.0.0.1'
	var _port = port
	var check

	var _socket_adress = "ws://"+_ip+":"+str(port)
	check = network.connect_to_url(_socket_adress, PoolStringArray(), true)
	#yield(self, 'connection_resoult')

	Global.get_tree().set_network_peer(null) #необходимо для ресета соединения
	Global.get_tree().set_network_peer(network)
	#BUG: нерабочая проверка
	if check == OK:
		Console.write_line("Welcome to chat!")
	else:
		Console.write_line("Connection error: "+ check)
		return

func disconnect_client():
	network.disconnect_from_host(1)

func _process(delta):
	if network:
		network.poll()



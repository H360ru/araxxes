extends Node

# TODO: #19 Серверный модуль
#  Пока простейшая демка чата в консоли
var login_name = 'default_nick'
var server_mode = 1

var network: NetworkedMultiplayerENet
var port = 1909
var max_peers = 100



#func _ready():
##	if server_mode:
##		create_server()
#	Console.write_line("Server node added")
#	pass

func create_multiplayer_peer(_mode = 0):
	network = NetworkedMultiplayerENet.new()
	
	#TODO: #26 доделать реакции на нетворк ивенты
	network.connect("connection_succeeded", self, "_on_peer_event")
	network.connect("connection_failed", self, "_on_peer_event")
	
	match _mode:
		1:
			# server side
			network.connect("peer_connected", self, "_on_client_connected")
			network.connect("peer_disconnected", self, "_on_client_disconnected")
		0:
			# client side
			network.connect("server_disconnected", self, "_on_peer_event")
	pass

func _on_peer_event(id = null):
	Console.write_line('connection_status: ' + str(network.get_connection_status()))

func create_server():
	create_multiplayer_peer(1)
	
	var check = network.create_server(port, max_peers)
	Global.get_tree().set_network_peer(network)
	if check == OK:
		Console.write_line("Server started")
	else:
		Console.write_line("Server creation error: "+check)
		return
	

func _on_client_connected(_user_id):
	Console.write_line("client_connected: "+str(_user_id))
	if !has_meta('players'):
		set_meta('players', {})
	get_meta('players')[_user_id] = 'name_'+str(_user_id)
	pass

func _on_client_disconnected(_user_id):
	Console.write_line("client_disconnected")
	pass

remote func _receive_message(_text, _login_name):
	rpc('_print_message', _text, _login_name)
#	Console.write_line("New_massege: " + _text)


func create_client():
	create_multiplayer_peer()
	
	var _ip = '127.0.0.1'
	var _port = 1909
	var check = network.create_client(_ip, _port)
	Global.get_tree().set_network_peer(network)
	if check == OK:
		Console.write_line("Welcome to chat!")
	else:
		Console.write_line("Connection error: "+ check)
		return

func _push_message(_text):
	rpc_id(1, '_receive_message', _text, login_name)

remotesync func _print_message(_text, _login_name):
	Console.write_line(_login_name+": "+ _text)


func allow_new_connections(_allow: bool):
	Global.get_tree().refuse_new_network_connections = !_allow

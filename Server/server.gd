extends Node

# @todo #9 Серверный модуль
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


func create_server():
	network = NetworkedMultiplayerENet.new()
	
	var check = network.create_server(port, max_peers)
	Global.get_tree().set_network_peer(network)
	if check == OK:
		Console.write_line("Server started")
	else:
		Console.write_line("Server creation error: "+check)
		return
	
	network.connect("peer_connected", self, "_on_client_connected")
	network.connect("peer_disconnected", self, "_on_client_disconnected")

func _on_client_connected(_user_id):
	Console.write_line("client_connected")
	pass

func _on_client_disconnected(_user_id):
	Console.write_line("client_disconnected")
	pass

remote func _receive_message(_text, _login_name):
	rpc('_print_message', _text, _login_name)
#	Console.write_line("New_massege: " + _text)


func create_client():
	network = NetworkedMultiplayerENet.new()
	
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

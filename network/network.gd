extends Node

var MESSAGE_AGENT: Node
var _request_queue: Array = []
enum message_type { request, response, chat_message }

class Request:
	extends Object
	var id: int

	signal data

	func response(_data):
		emit_signal('data', _data)
		print('Request delete')
		#free()
		call_deferred('free')

	func _init(_peer_id: int, _data):
		id = self.get_instance_id()
		var _mess = Message.new()
		_mess.pack(self.get_instance_id(), message_type.request, _data)
		Network.send_packet(_peer_id, _mess)
		
class Message:
	extends Resource
	var id: int
	var type: int
	var data

	# func _init(_id: int, _type: int, _data = null):
	# 	id = _id
	# 	type = _type
	# 	data = _data

	func pack(_id: int, _type: int, _data = null):
		id = _id
		type = _type
		if _data is Object:
			var dict = inst2dict(_data)
			Console.write_line('Dict ' +str(dict))
			data = var2bytes(dict)
		else:
			data = var2bytes(_data)
			pass
		
		return self


func _init():
	print('network init')
	

func _ready():
	print('network ready')
	create_message_agent()

#TODO: сделать возможность выбора протокола соединения через компоненты
func create_server(_cli: bool = true):
	var server = load(ProjectSettings.get_setting('global/server_path')).new()
	server.name = 'Server'
	yield(get_tree(),"idle_frame")
	add_child(server)
	server.create_server()
	create_chat_agent()

func create_client(_cli: bool = true):
	var _client = load(ProjectSettings.get_setting('global/client_path')).new()
	_client.name = 'Client'
	_client.login_name = '_login_name'
	yield(get_tree(),"idle_frame")
	add_child(_client)
	create_chat_agent()

func create_message_agent(_cli: bool = true):
	var _message_agent = load(ProjectSettings.get_setting('global/message_agent_path')).new()
	_message_agent.name = 'MessageAgent'
	
	yield(get_tree(), "idle_frame")
	add_child(_message_agent)
	MESSAGE_AGENT = _message_agent

func create_chat_agent(_cli: bool = true):
	Global.add_feature_component(self, 'Chat')



func has_client():
	pass

func request(_peer_id, _data):
	var req = Request.new(_peer_id, _data)
	_request_queue += [req]
	return req

# TODO: сделать оверрайд под клиент/сервер
# TODO: проверку пира отправителя
func _on_packet(_peer_id, _data):
	# if dict2inst(_two) is Lobby:
	#if _one is
	var _income = dict2inst(bytes2var(_data))
	Console.write_line('packet ' + str(dict2inst(bytes2var(_data))))
	if !_income:#.is_instance_valid():
		return
	match _income.type:
		message_type.request:
			var _d = bytes2var(_income.data)
			if _d == '_client':
				var _mess = Message.new()
				_mess.pack(_income.id, message_type.response, get_child(0)._client)
				Network.send_packet(_peer_id, _mess)
				pass

		message_type.response:
			var _d = dict2inst(bytes2var(_income.data))
			print('message_type.response: '+str(_d.data))
			instance_from_id(_income.id).response(_d)

	
	# Console.write_line('packet ' + str(_one) + ' ' + str(bytes2var(_two)))

func send_packet(_peer_id: int, _message):
	# Global.get_tree().multiplayer.send_bytes(var2bytes(inst2dict(_message)), 0)
	return get_tree().multiplayer.send_bytes(var2bytes(inst2dict(_message)), _peer_id)

# TODO: сделать подгрузку положения юнитов, сцены с сервера
# TODO: сделать возможность произвольного переподключения к серверу, выбор произвольного айпи

#не принимает null аргументы
remote func api_call(_object: Object, _method: String, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
	var _args_array = []
	if _arg1:
		_args_array += [_arg1]
	if _arg2:
		_args_array += [_arg2]
	if _arg3:
		_args_array += [_arg3]
	if _arg4:
		_args_array += [_arg4]
	
	var is_valid: bool = _object.callv(_method, _args_array)
	if !is_valid:
		return
	
	# TODO: заменить код ниже на объект, который можно оверрайднуть
	if get_tree().is_network_server():
		# сервер авторитарно обновляет состояния у остальных пиров
		var _arr = _args_array.duplicate()
		_arr.push_front(_method)
		for peer in get_tree().get_network_connected_peers():
			if peer != get_tree().get_rpc_sender_id():
				_arr.push_front(peer)
				_object.callv('rpc_id', _arr)
				_arr.remove(0)
	else:
		# клиент выполняет запрос на сервер
		if get_tree().network_peer.get_connection_status() == 2:
			var _arr = [1, 'server_call', _object.get_path(), _method, _args_array]
			Network.callv('rpc_id', _arr)

	pass

remote func api_call_old(_object: Object, _method: String):
	var is_valid: bool = _object.call(_method)
	if !is_valid:
		return
	# callv()
	# TODO: заменить код ниже на объект, который можно оверрайднуть
	if get_tree().is_network_server():
		# сервер авторитарно обновляет состояния у остальных пиров
		# Console.write_line('network_server')
		for peer in get_tree().get_network_connected_peers():
			if peer != get_tree().get_rpc_sender_id():
				_object.rpc_id(peer, _method, null)
	else:
		# клиент выполняет запрос на сервер
		# Console.write_line('network_client')
		if get_tree().network_peer.get_connection_status() == 2:
			# _object.rpc_id(1, _method)
			Network.rpc_id(1, 'server_call', _object.get_path(), _method)
			#Network.rpc_id(1, 'api_call', _object, _method) #.api_call(actor, 'move_path')
	pass

remote func api_callv(_object: Object, _method: String, _args_array: Array = []):
	var is_valid: bool = _object.callv(_method, _args_array)
	if !is_valid:
		return
	# callv()
	# TODO: заменить код ниже на объект, который можно оверрайднуть
	if get_tree().is_network_server():
		# сервер авторитарно обновляет состояния у остальных пиров
		# Console.write_line('network_server')
		var _arr = _args_array.duplicate()
		_arr.push_front(_method)
		for peer in get_tree().get_network_connected_peers():
			if peer != get_tree().get_rpc_sender_id():
				# _object.rpc_id(peer, _method, null)
				_arr.push_front(peer)
				_object.callv('rpc_id', _arr)
				_arr.remove(0)
	else:
		# клиент выполняет запрос на сервер
		# Console.write_line('network_client')
		if get_tree().network_peer.get_connection_status() == 2:
			# Network.rpc_id(1, 'server_call', _object.get_path(), _method)
			var _arr = [1, 'server_call', _object.get_path(), _method, _args_array]
			Network.callv('rpc_id', _arr)

	pass

remote func server_call(_node_path: NodePath, _method: String, _args_array: Array = []):
	# TODO: проверка принадлежит ли текущий ход пиру
	
	var _object = get_tree().get_root().get_node_or_null(_node_path)
	if !_object:
		return
	var is_valid: bool = _object.callv(_method, _args_array)
	if !is_valid:
		return
	
	var _arr = _args_array.duplicate()
	_arr.push_front(_method)
	for peer in get_tree().get_network_connected_peers():
		if peer != get_tree().get_rpc_sender_id():
			#_object.rpc_id(peer, _method)
			_arr.push_front(peer)
			_object.callv('rpc_id', _arr)
			_arr.remove(0)

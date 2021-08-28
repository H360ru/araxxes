extends Component

var _request_queue: Array = []
enum message_type { request, response, chat_message }

func _init():
	discription = 'Агент байт сообщений версия 0.1'

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
		Network.MESSAGE_AGENT.send_packet(_peer_id, _mess)
		
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

			#Console.write_line('Dict ' +str(dict))
			
			data = var2bytes(dict)
		else:
			data = var2bytes(_data)
			pass
		
		return self

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
	#Console.write_line('packet ' + str(dict2inst(bytes2var(_data))))
	if !_income:#.is_instance_valid():
		return
	match _income.type:
		message_type.request:
			var _d = bytes2var(_income.data)
			if _d == '_client':
				var _mess = Message.new()
				_mess.pack(_income.id, message_type.response, Network.get_node('Client')._client)
				send_packet(_peer_id, _mess)
				pass

		message_type.response:
			var _d = dict2inst(bytes2var(_income.data))
			print('message_type.response: '+str(_d.data))
			instance_from_id(_income.id).response(_d)
		
		message_type.chat_message:
			#var _d = dict2inst(bytes2var(_income.data))
			var _d = bytes2var(_income.data)
			Global.component_call('Chat', '_print_message', [_d, _peer_id])
			pass
			

	
	# Console.write_line('packet ' + str(_one) + ' ' + str(bytes2var(_two)))

#TODO: connection check
func send_packet(_peer_id: int, _message):
	# Global.get_tree().multiplayer.send_bytes(var2bytes(inst2dict(_message)), 0)
	return get_tree().multiplayer.send_bytes(var2bytes(inst2dict(_message)), _peer_id)

func _test_component():
	Console.write_line(name+': test_component')



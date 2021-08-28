extends Node

# TODO: Класс оболочка отвечает за прием высокоуровневых команд от игрока/бота
# и их правильное перенаправление на уровни ниже в сингловой сессии/сервере

#не принимает null аргументы
func api_call(_object: Object, _method: String, _arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null):
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

func api_callv(_object: Object, _method: String, _args_array: Array = []):
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





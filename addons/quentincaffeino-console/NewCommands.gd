# TODO #27 Дополнительные команды для консоли
extends Reference


# @var  Console
var _console


# @param  Console  console
func _init(console):
	self._console = console

	self._console.add_command('help_test', self, '_help_test')\
		.set_description('Outputs usage instructions.')\
		.add_argument('command', TYPE_STRING)\
		.register()
	
	self._console.add_command('try_call', self, '_try_call')\
		.set_description('Outputs usage instructions.')\
		.add_argument('command', TYPE_STRING)\
		.add_argument('node', TYPE_STRING)\
		.add_argument('arg', TYPE_STRING)\
		.register()
	
	self._console.add_command('input', self, 'input')\
		.register()
	
	self._console.add_command('chat', self, '_chat')\
		.add_argument('login_name', TYPE_STRING)\
		.register()
	
	self._console.add_command('server_chat', self, '_server_chat')\
		.register()
	
	self._console.add_command('show_lobby', self, '_show_lobby')\
		.register()
	
	self._console.add_command('show_components', self, '_show_components')\
		.register()
	
	self._console.add_command('reconnect', self, '_reconnect')\
		.register()
	
	self._console.add_command('disconnect', self, '_disconnect')\
		.register()
	
	self._console.add_command('close_chat', self, '_close_chat_ui')\
		.register()
	
	self._console.add_command('screen_orientation', self, '_screen_orientation')\
		.register()


# Display help message or display description for the command.
# @param    String|null  command_name
# @returns  void
func _help_test(command_name = null):
	if command_name:
		var command = self._console.get_command(command_name)

		if command:
			command.describe()
		else:
			self._console.Log.warn('No help for `' + command_name + '` command were found.')

	else:
		self._console.write_line(\
			"Ну чо, привет: "+Global.SETTINGS.b)

#TO_DO:
func input():
#	SettingsSaveLoad.save_settings_config(SettingsControls.get_input_data())
#	print(SettingsControls.get_input_data())
	var inp = SettingsControls.get_input_data()
	for key in inp.keys():
		print(key)
		var actions = inp[key]
		for i in inp[key].keys():
#			print('# ', i)
			for k in actions[i].values():
				if k is int:
					print('## ', OS.get_scancode_string(k))
				else:
					print('## ', k)#, ': ', actions[i][k])

func _server_chat():
	var server = Global.get_tree().get_root().get_node_or_null('Server')
	if !server:
		server = load('res://Server/Server.tscn').instance()
		Global.get_tree().get_root().add_child(server)
	#	yield(server, "ready")
	# TODO: проверить соединение
		server.create_server()
	
	var _exit = true
	var prefix = '!'
	_console.Line.disconnect('text_entered', _console.Line, 'execute')
#	self._console.Line.connect('text_entered', self, "_chat_message")
	while _exit:
		yield(self._console.Line,'text_entered')
		if self._console.Line.text.begins_with(prefix):
			match _console.Line.text:
				'!exit':
					_console.Line.clear()
					_exit = false
				'!players':
					_console.Line.clear()
					_console.write_line(str(server.get_meta('lobby').players))
				_:
					_console.Line.clear()
					self._console.write_line('Unknown chat command')
		else:
			_chat_message(self._console.Line.text)
#		var text_buff = self._console.Line.text
#		_console.clear()
#		self._console.write_line("chat: "+ text_buff)
#	self._console.Line.disconnect('text_entered', self, "_chat_message")
	_console.Line.connect('text_entered', _console.Line, 'execute')
	server.queue_free()
	self._console.write_line('Exited server app')

func _chat(_login_name):
	# TODO: проверить соединение
	
	var _exit = true
	var prefix = '!'
	_console.Line.disconnect('text_entered', _console.Line, 'execute')
#	self._console.Line.connect('text_entered', self, "_chat_message")
	while _exit:
		yield(self._console.Line,'text_entered')
		if self._console.Line.text.begins_with(prefix):
			if _console.Line.text == '!exit':
				_console.Line.clear()
				_exit = false
			else:
				_console.Line.clear()
				self._console.write_line('Unknown chat command')
		else:
			_chat_message(self._console.Line.text)
#		var text_buff = self._console.Line.text
#		_console.clear()
#		self._console.write_line("chat: "+ text_buff)
#	self._console.Line.disconnect('text_entered', self, "_chat_message")
	_console.Line.connect('text_entered', _console.Line, 'execute')
	self._console.write_line('Exited chat app')

func _chat_message(_text):
	_console.Line.clear()
	Global.component_call('Chat', '_push_message', [_text])
	
func _show_lobby():
	self._console.write_line(str(Network.get_node('Server').get_meta('lobby').get_players()))

func _show_components():
	#self._console.write_line(str(Global.COMPONENTS.has('Client')))
	for i in Global.COMPONENTS:
		self._console.write_line("[color=#66ffff][url="+str(i)+"]"+str(i)+"[/url][/color]"+": "+str(Global.COMPONENTS[i].discription))
		# var m_list = Global.COMPONENTS[i].get_method_list()
		# var m_name_list = []
		# for inx in m_list:
		# 	m_name_list += [inx['name']]
		# self._console.write_line(str(m_name_list))
	# Возможно, синглтонам/сущностям "контейнерам компонентов" нужно наследоваться от общего родителя
	#Global.component_call('MessageAgent', '_test_component')
	#Global.COMPONENTS['MessageAgent'].set_process(false)
#		self._console.write_line(str(i.name)+": "+str(i.discription))

func _close_chat_ui():
	Global.get_component('ChatUI').queue_free()

func _reconnect():
	Global.component_call('Client', 'connect_to_ip')

func _disconnect():
	Global.component_call('Client', 'disconnect_client')

func _try_call(command_name = null, node = null, arg = ['тест1', 'тест2']):
	if command_name:
#		var command = self._console.get_command(command_name)
		self._console.write_line(\
			"Пытаемся найти: "+command_name+' '+str(node))
		var command = Global.get_tree().get_root().find_node(command_name, true, false)
		if command:
#			command.describe()
			self._console.write_line(\
			"Нашел: "+command.to_string())
			var m_list = ClassDB.class_get_method_list("GDScript")
			var m_name_list = []
			for inx in m_list:
#				inx = inx['name']
#				print(inx)
				m_name_list += [inx['name']]
#			print("method_list ", m_name_list)#[0]['name'])
			if str(node) != "print":
				if command.has_method(node): #ClassDB.class_has_method(command.get_class(), str(node)):# @GDScript
					self._console.write_line(\
					"есть метод: "+str(node))
					command.call(node, arg.split(','))
			else:
				self._console.write_line(\
				"есть метод: "+str(node))
				command.call(node, arg)
		else:
			self._console.Log.warn('Не могу найти `' + command_name + '` command were found.')

	else:
		self._console.write_line(\
			"Ну чо, привет: "+Global.SETTINGS.b)

# Prints out engine version.
# @returns  void
func _version():
	self._console.write_line(Engine.get_version_info())


# @returns  void
func _list_commands():
	for command in self._console._command_service.values():
		var name = command.getName()
		self._console.write_line('[color=#ffff66][url=%s]%s[/url][/color]' % [ name, name ])


# Quitting application.
# @returns  void
func _screen_orientation():
	self._console.write_line(Global.get_screen_orientation())

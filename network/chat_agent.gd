extends Component

var _login: String = 'no_login'

signal message

func _init():
	discription = 'Агент чата версия 0.1'
	
	var _check = Global.COMPONENTS.get('Client')
	if _check:
		_login = _check._client.data.get('login')

	Global.add_feature_component(self, 'ChatUI')

func _push_message(_text):
	var _mess = Network.Message.new()
	_mess.pack(self.get_instance_id(), Network.message_type.chat_message, _text)
	Network.MESSAGE_AGENT.send_packet(0, _mess)
	_print_message(_text, _login)
#BUG: айди вместо логина
func _print_message(_text, _login_name):
	Console.write_line(str(_login_name)+": "+ _text)
	emit_signal('message', _text, _login_name)

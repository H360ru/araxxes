extends Component

var _login: String = 'no_login'
var text: Node

func _init():
	discription = 'UI чата версия 0.1'

	text = RichTextLabel.new()
	text.rect_min_size = Vector2(400,200)
	text.rect_position = Vector2(40,400)
	Global.add_child(text)

func _ready():
	get_parent().connect('message', self, '_write_line')
	
func _write_line(_text, _login_name):
	var message = str(str(_login_name)+": "+ _text)
	text.set_bbcode(text.get_bbcode() + message + '\n')

func _exit_tree():
	text.queue_free()

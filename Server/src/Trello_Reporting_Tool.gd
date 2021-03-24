extends Panel

#TODO: при добавлении в игру не забыть поставить в глобальный контекс и все дела
var player_name = "Player name"

# Trello Reporting Tool - by Raffaele Picca: twitter.com/MV_Raffa
# Вот его гит:
# https://github.com/RPicster/Godot-Trello-Reporting-Tool

# The URL pointing to the webserver location where "proxy.php" from this
# repository is served.
const PROXY_URL = 'https://disjoint-pictures.000webhostapp.com/message.php'#proxy.php'

# Internal constants, only change if you must ;-)
const POST_BOUNDARY: String = 'GodotFileUploadBoundaryZ29kb3RmaWxl'
const URL_REGEX: String = \
	'^(?:(?<scheme>https?)://)?' + \
	'(?<host>\\[[a-fA-F0-9:.]+\\]|[^:/]+)' + \
	'(?::(?<port>[0-9]+))?(?<path>$|/.*)'

# If you don't want to use labels, just leave this dictionary empty, you can
# add as many labels as you need by just expanding the library.
#
# To find out the label ids, use the same way as with the list ids. look for
# the label ids in the Trello json.
var  trello_labels = {}

#var trello_labels = {
#	0 : {
#		"label_trello_id"	: "LABEL ID FROM TRELLO",
#		"label_description"	: "Label name for Option Button"
#	},
#	1 : {
#		"label_trello_id"	: "LABEL ID FROM TRELLO",
#		"label_description"	: "Label name for Option Button"
#	}
#}

onready var timer = $TimeoutTimer
onready var http = HTTPClient.new()
onready var short_text = $Content/Form/ShortDescEdit
onready var long_text = $Content/Form/LongDescEdit
onready var send_button = $Content/Form/Custom/Send
onready var feedback = $Content/Feedback/feedback_label
onready var close_button = $Content/Feedback/close_button

func _ready():
	timer.set_wait_time(0.2)
	if !trello_labels.empty():
		for i in range(trello_labels.size()):
			$Content/Form/Custom/Type.add_item(trello_labels[i].label_description, i)
		$Content/Form/Custom/Type.selected = 0
	else:
		$Content/Form/Custom/Type.hide()

	# call this to show and reset the window
	show_window()

func show_window():
	show()
	$Content/Form.show()
	$Content/Feedback.hide()
	short_text.grab_focus()
	short_text.text = ""
	long_text.text = ""
	$Content/Form/Custom/Type.selected = 0

func _on_Send_pressed():
	show_feedback()
	create_card()

class Attachment:
	# XXX: This is to prevent reference cycles (and thus memleaks), see:
	# https://github.com/godotengine/godot/issues/27491
	class Struct:
		var filename: String
		var mimetype: String
		var data: PoolByteArray

	static func from_path(path: String) -> Attachment.Struct:
		var obj = Attachment.Struct.new()
		obj.filename = path.get_file()

		match path.get_extension():
			'png':
				obj.mimetype = 'image/png'
			'jpg', 'jpeg':
				obj.mimetype = 'image/jpeg'
			'gif':
				obj.mimetype = 'image/gif'
			_:
				obj.mimetype = 'application/octet-stream'

		var file = File.new()
		if file.open(path, File.READ) != OK:
			return null
		obj.data = file.get_buffer(file.get_len())
		file.close()

		return obj

	static func from_image(img: Image, name: String) -> Attachment.Struct:
		var obj = Attachment.Struct.new()
		obj.filename = name + '.png'
		obj.mimetype = 'image/png'
		obj.data = img.save_png_to_buffer()
		return obj

func create_post_data(key: String, value) -> PoolByteArray:
	var body: PoolByteArray
	var extra: String = ''
	var bytes: PoolByteArray

	if value is Array:
		for idx in range(0, value.size()):
			var newkey = "%s[%d]" % [key, idx]
			body += create_post_data(newkey, value[idx])
		return body
	elif value is Attachment.Struct:
		extra = '; filename="' + value.filename + '"'
		if value.mimetype != 'application/octet-stream':
			extra += '\r\nContent-Type: ' + value.mimetype
		bytes = value.data
	elif value != null:
		bytes = value.to_utf8()

	var buf = 'Content-Disposition: form-data; name="' + key + '"' + extra
	body += ('--' + POST_BOUNDARY + '\r\n' + buf + '\r\n\r\n').to_ascii()
	body += bytes + '\r\n'.to_ascii()
	return body

func send_post(http: HTTPClient, path: String, data: Dictionary) -> int:
	var headers = [
		'Content-Type: multipart/form-data; boundary=' + POST_BOUNDARY,
	]

	var body: PoolByteArray
	for key in data:
		body += create_post_data(key, data[key])
	body += ('--' + POST_BOUNDARY + '--\r\n').to_ascii()

	return http.request_raw(HTTPClient.METHOD_POST, path, headers, body)

func parse_url(url: String) -> Dictionary:
	var regex = RegEx.new()

	if regex.compile(URL_REGEX) != OK:
		return {}

	var re_match = regex.search(url)
	if re_match == null:
		return {}

	var scheme = re_match.get_string('scheme')
	if not scheme:
		scheme = 'http'

	var port: int = 80 if scheme == 'http' else 443
	if re_match.get_string('port'):
		port = int(re_match.get_string('port'))

	return {
		'scheme': scheme,
		'host': re_match.get_string('host'),
		'port': port,
		'path': re_match.get_string('path'),
	}

func create_card():
	var data = {
		'name': short_text.text,
		'desc': (long_text.text + "\n\n**Operating System:** " + OS.get_name()),
		'player_name': player_name,
	}

	if !trello_labels.empty():
		var type = $Content/Form/Custom/Type.selected
		data['label_id'] = trello_labels[type].label_trello_id

	# The cover attachment must be an image. If you don't want so sent further
	# attachments, just leave attachments empty.
	#
	# Use the function Attachment.from_path() to attach files from the
	# filesystem or Attachment.from_image() to convert an Image instance to a
	# file.
	
	#Пример типо скриншота, аналогично можно прицепить логи с ошибками и т.д.
	data['attachments'] = Attachment.from_path("res://icon.png")
	
	#Обложка нужна для карточек трелло, потом приведу код в порядок, конечно
	data['cover'] = Attachment.from_path("res://icon.png")

	#ВАЖНО: Лимит размера отдельного файла 8 метров
	# и максимум 10 приложенных файлов (для дискорд)
	
#	data['attachments'] = [
#		Attachment.from_image(
#			OpenSimplexNoise.new().get_image(200, 200), 'noise1'
#		),
#		Attachment.from_image(
#			OpenSimplexNoise.new().get_image(200, 200), 'noise2'
#		),
#	]

	var parsed_url = parse_url(PROXY_URL)
	if parsed_url.empty():
		change_feedback("Wrong proxy URL provided, can't send data :-(")
		return

	http.connect_to_host(
		parsed_url['host'],
		parsed_url['port'],
		parsed_url['scheme'] == 'https'
	)

	var timeout = 30.0
	timer.start()
	while http.get_status() in [
		HTTPClient.STATUS_CONNECTING,
		HTTPClient.STATUS_RESOLVING
	]:
		http.poll()
		yield(timer, 'timeout')
		timeout -= timer.get_wait_time()
		if timeout < 0.0:
			change_feedback("Timeout while waiting to connect to server :-(")
			timer.stop()
			return
	timer.stop()

	if http.get_status() != HTTPClient.STATUS_CONNECTED:
		change_feedback("Unable to connect to server :-(")
		return

	if send_post(http, parsed_url['path'], data) != OK:
		change_feedback("Unable to send feedback to server :-(")
		return

	timeout = 30.0
	timer.start()
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		http.poll()
		yield(timer, 'timeout')
		timeout -= timer.get_wait_time()
		if timeout < 0.0:
			change_feedback("Timeout waiting for server acknowledgement :-(")
			timer.stop()
			return
	timer.stop()

	if not http.get_status() in [
		HTTPClient.STATUS_BODY,
		HTTPClient.STATUS_CONNECTED
	]:
		change_feedback("Unable to connect to server :-(")
		return

	if http.has_response() && http.get_response_code() != 200:
		timeout = 30.0
		timer.start()
		var response: PoolByteArray
		while http.get_status() == HTTPClient.STATUS_BODY:
			http.poll()
			var chunk = http.read_response_body_chunk()
			if chunk.size() == 0:
				yield(timer, 'timeout')
				timeout -= timer.get_wait_time()
				if timeout < 0.0:
					change_feedback("Timeout waiting for server response :-(")
					timer.stop()
					return
			else:
				response += chunk
		timer.stop()
		feedback.text = 'Error from server: ' + response.get_string_from_utf8()
		return

	change_feedback("Feedback sent successfully, thank you!")

func show_feedback():
	#disable all input fields and show a short message about the current status
	$Content/Form.hide()
	$Content/Feedback.show()
	change_feedback("Your feedback is being sent...", true)

func change_feedback(new_message: String, close_button_disabled: bool = false) -> void:
	feedback.text = new_message
	close_button.disabled = close_button_disabled
	close_button.text = "Please wait" if close_button_disabled else "Close"
	close_button.grab_focus()

func _on_ShortDescEdit_text_changed(_new_text) -> void:
	update_send_button()

func _on_LongDescEdit_text_changed() -> void:
	update_send_button()

func update_send_button() -> void:
	# check if text is entered, if not, disable the send button
	send_button.disabled = (long_text.text == "" or short_text.text == "" or player_name == null)

func _on_close_button_pressed():
	hide()

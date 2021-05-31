extends Node
# @todo #9 Менеджер звуков
#  Пока поддерживает только простейшие глобальные звуки (без учета удаленности)
class_name SoundManager

# Declare member variables here. Examples:
# var a = 2
var init_sounds = {
	"ui_accept": "res://addons/SoundManager/SFX/wpn_select.wav",
	"ui_deny": "res://addons/SoundManager/SFX/wpn_denyselect.wav",
	"ui_set": "res://addons/SoundManager/SFX/wpn_hudoff.wav",
}

var library = {}

# Called when the node enters the scene tree for the first time.
func _init():
	load_sounds(init_sounds)

func set_volume(volume: float, bus_inx = 0):
	AudioServer.set_bus_volume_db(bus_inx, volume)

func play(sound_name: String = 'ui_accept'):
	if !library[sound_name].is_playing():
		library[sound_name].play()
		print("SOUND")
	return library[sound_name]

# нужна ли функция?
func async_play_until_signal(_sound_name: String, _object: Object, _signal: String):
	var _sound = play(_sound_name)
	set_loop_mode(_sound.stream, 1)
	yield(_object, _signal)
	_sound.stop()

func load_sounds(init_sounds: Dictionary):
	prints("Lib test:", init_sounds)
	for name in init_sounds:
		library[name] = create_player(init_sounds[name])
		prints('Library:', library[name])

func create_player(sound_path: String):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = load(sound_path)
#	player.stream.loop_mode = 1
	set_loop_mode(player.stream, 0)
#	print(player.stream)
	return player

func set_loop_mode(_stream: AudioStream, _mode: int):
	if _stream is AudioStreamOGGVorbis:
		_stream.loop = bool(_mode)
	else:
		_stream.loop_mode = _mode

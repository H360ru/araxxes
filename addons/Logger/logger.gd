extends Node

# Логгер
# Логи сохраняются в папке logs_path
# Пресеты настраиваются через ини файл, путь к кторому в logs_config_path
# Секция - название группы
# Все параметры это строковые литералы, записанные !только! строчными буквами. 
# Если необходимо указать несколько, перечисляются через запятую без пробелов под одними кавычками. 
# Доступные параметры:
# @write_to - куда будет логироваться
#       "file" - логгируется в файл
#       "console" - логгируется в консоль
# @write_tags - какие теги логгирует эта группа (при несовпадении запрос лога просто игнорируется)
#       Варианты см. Tags

class __Message:
	# Класс, чтобы собрать все данные для лога в кучу
	var msg_string:String
	var msg_time:float
	var msg_group:String
	var msg_tag:int
	var msg_numb:int
	
	func _init(numb, group, time, string, tag):
		msg_numb = numb
		msg_string = string
		msg_time = time
		msg_group = group
		msg_tag = tag


enum Tags{
	TRACE,
	INFO,
	ALART
}

const logs_path = "res://logs/"
const logs_config_path = "res://logs/logs_presets.ini"

var _message_number:int = 1 # номер сообщения
var _file:File # csv файл для записи
var _config_file:ConfigFile # ini файл для чтения конфигов
var _init_time = _get_time_in_secs() # время старта программы

func _enter_tree():
	_file = File.new()
	var path = logs_path+_get_log_file_name()
	_file.open(path, _file.WRITE)
	_file.store_csv_line(_get_log_file_header(), ";")
	
	_config_file = ConfigFile.new()
	assert(_config_file.load(logs_config_path)==OK)

func _exit_tree():
	_file.close()

func _ready():
	log_text("Logger", "Logger ready", Tags.INFO)

func log_text(group:String, msg:String, tag:int):
	if not _is_group_allow_setting(group, "write_tags", _gtnfi(tag).to_lower()):
		return 
	
	var time = _get_time_from_init()
	var message = _create_mesage(_message_number, group, time, msg, tag)
	var string = _get_formated_message(message)
	
	_message_number += 1
	
	if _is_group_allow_setting(group, "write_to", "console"):
		Console.write_line(string)
		
	if _is_group_allow_setting(group, "write_to", "file"):
		_log_to_file(message)

func _log_to_file(message:__Message):
	_file.store_csv_line([message.msg_numb, message.msg_group, message.msg_time, _gtnfi(message.msg_tag), message.msg_string], ";")
	
func _get_formated_message(message:__Message):
	var string = "{} | {} | {} | {} | {}".format(["%7-s"%message.msg_numb, "%15-s"%message.msg_group, "%8.3-f"%message.msg_time, "%9-s"%_gtnfi(message.msg_tag), message.msg_string], "{}")
	return string
	
func _get_log_file_name():
	var date = OS.get_datetime()
	var date_str = str(date["day"]) + "-" + str(date["month"]) + "-" +  str(date["year"]) + "-" +   str(date["hour"]) + "-" +  str(date["minute"]) + "-" +  str(date["second"])+".csv"
	return date_str
	
func _get_log_file_header():
	return ["N", "Group Name", "Time (sec)", "Tag", "Message"]

func _get_time_in_secs():
	return OS.get_ticks_msec()/1000.0
	
func _get_time_from_init():
	return _get_time_in_secs() - _init_time
	
func _create_mesage(numb:int, group:String, time:float, msg:String, tag:int):
	return __Message.new(numb, group, time, msg, tag)
	
func _gtnfi(numb:int): # get tag name from integer
	return Tags.keys()[numb]

func _config_has_group(group:String): # есть ли в ini файле секция group
	return group in _config_file.get_sections()

func _config_group_has_setting(group:String, setting:String): # есть ли в ini файле в секции group параметр setting
	if not _config_has_group(group):
		return false
		
	return setting in _config_file.get_section_keys(group)

func _get_values_from_csv(string:String, sep:String=","): # разбивает строку с разделителем sep
	return string.split(sep)

func _is_group_allow_setting(group:String, setting:String, value:String): # есть ли value в параметре setting
	if not _config_group_has_setting(group, setting): # если нет группы или нет параметра в группе, то считается что не ограничивается
		return true
	
	var values = _get_values_from_csv(_config_file.get_value(group, setting))
	
	return value in values

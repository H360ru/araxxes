extends Node

# Логгер
# Логи сохраняются в папке logs_path
# Пресеты настраиваются через ини файл, путь к кторому в logs_config_path

enum Tags{
	TRACE,
	INFO,
	ALART
}

const logs_path = "res://logs/"
const logs_config_path = "res://logs/logs_presets.ini"

var _message_number:int = 1 # номер сообщения
var _file:File # csv файл для записи
var _config:LogConfig # объект для работы с конфигом
var _init_time = _get_time_in_secs() # время старта программы
var _default_preset:LogPrinter # стандартный вывод
var _groups_presets:Dictionary # имя группы : объект LogPrinter

func _enter_tree():
	_file = File.new()
	var path = logs_path+_get_log_file_name()
	_file.open(path, _file.WRITE)
	_file.store_csv_line(_get_log_file_header(), ";")
	
	var config_file = ConfigFile.new()
	assert(config_file.load(logs_config_path)==OK)
	_config = LogConfig.new(config_file)
	
	_groups_presets = {} 
	
	_default_preset = _create_preset_for_group("DEFAULT")
	
	for i in _config.get_groups(): # парс конфиг файла в словарь
		if i == "DEFAULT":
			continue
		
		var preset = _create_preset_for_group(i)
		
		_groups_presets[i] = preset
	
	_delete_extra_logs(10)

func _exit_tree():
	_file.close()


func _ready():
	log_text("Logger", "Logger ready", Tags.INFO)


func log_text(group:String, msg:String, tag:int):
	var message = _create_mesage(_message_number, group, _get_time_from_init(), msg, tag)
	
	var t = _groups_presets.get(group)
	
	if t == null:
		_default_preset.message(message)
	else:
		t.message(message)
		
	_message_number += 1


func _log_to_console(message:LogMessage):
	var string = _get_formated_message(message)
	Console.write_line(string)


func _log_to_file(message:LogMessage):
	_file.store_csv_line([message.msg_numb, message.msg_group, message.msg_time, _gtnfi(message.msg_tag), message.msg_string], ";")


func _get_formated_message(message:LogMessage):
	var string = "{} | {} | {} | {} | {}".format(["%7-s"%message.msg_numb, "%15-s"%message.msg_group, "%8.3-f"%message.msg_time, "%9-s"%_gtnfi(message.msg_tag), message.msg_string], "{}")
	return string


func _get_log_file_name():
	var date = OS.get_datetime()
	var date_str = str(date["day"]) + "-" + str(date["month"]) + "-" +  str(date["year"]) + "-" +   str(date["hour"]) + "-" +  str(date["minute"]) + "-" +  str(date["second"])+".csv"
	return date_str


func _get_log_file_header():
	return ["N", "Group Name", "Time (sec)", "Tag", "LogMessage"]


func _get_time_in_secs():
	return OS.get_ticks_msec()/1000.0


func _get_time_from_init():
	return _get_time_in_secs() - _init_time


func _create_mesage(numb:int, group:String, time:float, msg:String, tag:int):
	return LogMessage.new(numb, group, time, msg, tag)


func _gtnfi(numb:int): # get tag name from integer
	return Tags.keys()[numb]


func _create_preset_for_group(group):
	var tags = Tags.keys() # список имен тегов
	
	var funcrefs = []
	var allowed_tags = []
	
	if _config.is_group_allow_setting(group, "write_to", "console"):
		funcrefs.append(funcref(self, "_log_to_console"))
		
	if _config.is_group_allow_setting(group, "write_to", "file"):
		funcrefs.append(funcref(self, "_log_to_file"))
		
	for j in tags:
		if _config.is_group_allow_setting(group, "write_tags", j):
			allowed_tags.append(Tags[j])
	
	var preset = LogPrinter.new(funcrefs, allowed_tags)
	
	return preset


func _delete_extra_logs(max_to_hold):
	var dir = Directory.new()
	assert(dir.open(logs_path) == OK)
	var csv_files = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".csv"):
			csv_files.append(file_name.substr(0, file_name.length()-4))
			
		file_name = dir.get_next()
		
	if len(csv_files) < max_to_hold+1:
		return 
	
	# Возможно просто называть файл кол-вом секунд с начала эпохи для простоты сравнения
	# Для сравнения можно было бы использовать дату изменения, но это очень долгое сравнение, 
	# ибо надо открыть файл, считать время, закрыть файл. По имени гораздо быстрее
	csv_files.sort_custom(self, "_compare_files_with_date_as_name")
	
	# убираем лишнее (дорогу молодым)
	for i in range(max_to_hold, len(csv_files)):
		dir.remove(csv_files[i]+".csv") 


func _compare_files_with_date_as_name(a:String, b:String):
	var at = a.split("-") as Array
	var bt = b.split("-") as Array
	
	if at[2] != bt[2]:
		return int(at[2]) > int(bt[2])
		
	elif at[1] != bt[1]:
		return int(at[1]) > int(bt[1])
		
	elif at[0] != bt[0]:
		return int(at[0]) > int(bt[0])
		
	elif at[3] != bt[3]:
		return int(at[3]) > int(bt[3])
		
	elif at[4] != bt[4]:
		return int(at[4]) > int(bt[4])
		
	else:
		return int(at[5]) > int(bt[5])


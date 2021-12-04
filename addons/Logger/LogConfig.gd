extends Reference

class_name LogConfig

# Объект для удобной работы с ini в установленном формате
# Секция - название группы; Регистр учитывается; Пробелы учитываются
# Все параметры это строковые литералы; регистр НЕ учитывается; Пробелы перед запятой и после также НЕ учитываются;
# Если необходимо указать несколько, перечисляются через запятую под одними кавычками. 
# Доступные параметры:
# @write_to - куда будет логироваться
#       "file" - логгируется в файл
#       "console" - логгируется в консоль
# @write_tags - какие теги логгирует эта группа (при несовпадении запрос лога просто игнорируется)
#       Варианты см. Logger.Tags
# Если нет парметра, то считается, что он ничего не ограничивает
# Если нет группы, то в ее выводе ничего не ограничивается

# Пример:
# [Units]
# write_to = "FiLe, coNsolE" # будет работать
# write_tags = " iNfo, alArt"

var _config_file:ConfigFile

func _init(file:ConfigFile):
	_config_file = file

func is_group_allow_setting(group:String, setting:String, value:String): # есть ли value в параметре setting
	if not group_has_setting(group, setting): # если нет группы или нет параметра в группе, то считается что не ограничивается
		return true
	
	var csv_values = _config_file.get_value(group, setting)
	
	return _is_value_in_csv(value.dedent().to_lower(), csv_values)

func get_groups():
	return _config_file.get_sections()
	
func has_group(group:String): # есть ли секция group
	return group in _config_file.get_sections()

func group_has_setting(group:String, setting:String): # есть в секции group параметр setting
	if not has_group(group): 
		return false
		
	return setting in _config_file.get_section_keys(group)
	
func _is_value_in_csv(value:String, csv:String): # проверяет на содержание без учета пробелов по краям и без учета регистра
	value = value.to_lower().dedent()
	
	for i in csv.split(","):
		if i.to_lower().dedent() == value:
			return true
			
	return false

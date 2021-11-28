extends Reference

class_name LogMessage

# класс, собирающий в кучу все данные для сообщения

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

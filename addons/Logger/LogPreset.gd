extends Reference

class_name LogPrinter

var outputs:Array = []
# возможно сделать отдельный объект LogMask
var allowed_tags:Array = [] 

func _init(i_outputs:Array, i_allowed_tags:Array):
	outputs = i_outputs.duplicate()
	allowed_tags = i_allowed_tags.duplicate()

func message(msg:LogMessage):
	if not msg.msg_tag in allowed_tags:
		return
		
	for i in outputs:
		i.call_func(msg)

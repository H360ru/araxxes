#extends Node
#extends Resource
#
#class_name ClientData
#
#var login: String
#var password: String
#
#func _init(_login = null, _password = null):
#	login = _login
#	password = _password
#
#	#DEBUG HACK:
#	if !(_login or _password):
#		printerr('ClientData null instantiation!!!')

extends CanvasLayer

func _init():
	set_script(load(ProjectSettings.get_setting('global/global_path')))
	yield(self, "script_changed")
#	return


extends Control

func _on_back():
	get_parent()._back()

func _on_harv():
	Kostil.GAME.whoToPlay=0
	Kostil.GAME.newGame()
	Kostil.open_tutorial()
	Kostil.background_visible(false)
	get_parent().visible = false

func _on_worm():
	Kostil.GAME.whoToPlay=1
	Kostil.GAME.newGame()
	Kostil.open_tutorial()
	Kostil.background_visible(false)
	get_parent().visible = false

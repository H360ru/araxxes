extends Node2D

class_name ProjectilesManager

signal projectile_moved(projectile)
signal all_projectiles_moved
signal projectile_launched(projectile)

var projectiles_in_move:int = 0

func launch_projectile_between_global(projectile:PackedScene, glob1:Vector2, glob2:Vector2, del_as_default=true):
	var proj:Projectile = projectile.instance() as Projectile
	add_child(proj)
	
	proj.connect("launched", self, "_on_projectile_launched", [proj])
	proj.connect("moved", self, "_on_projectile_moved", [proj, del_as_default])
	
	projectiles_in_move += 1
	proj.fly_between_globals(glob1, glob2)
	
	
func delete_projectile(proj:Projectile):
	proj.queue_free()
	
func _on_projectile_moved(proj:Projectile, del_as_default):
	emit_signal("projectile_moved", proj)
	
	if del_as_default:
		delete_projectile(proj)
	
	projectiles_in_move -= 1
	if projectiles_in_move == 0:
		emit_signal("all_projectiles_moved")
	
func _on_projectile_launched(proj:Projectile):
	emit_signal("projectile_launched", proj)

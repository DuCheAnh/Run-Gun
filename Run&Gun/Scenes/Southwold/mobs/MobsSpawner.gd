extends Node2D

#var firemob_waittime=0.5
#var firemob=preload("res://Scenes/Southwold/mobs/FireMob.tscn")
#export (int) var firingdir=-1
#func firemob_spawner(dir):
#	var inst=firemob.instance()
#	inst.dir=firingdir
#	inst.position=$FirePos.position
#	add_child(inst)
#
#func _physics_process(delta):
#	if $FirePosTimer.is_stopped():
#		firemob_spawner(firingdir)
#		$FirePosTimer.start()
#
#
func _on_FirePosTimer_timeout():
	pass
#	$FirePosTimer.stop()

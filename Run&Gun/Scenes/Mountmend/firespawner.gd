extends Node2D

var firemob_waittime=0.5
var firemob=preload("res://Scenes/Southwold/mobs/FireMob.tscn")
export (int) var firingdir=-1
func firemob_spawner(dir):
	var inst=firemob.instance()
	inst.dir=firingdir
	inst.position=$Position2D.position
	add_child(inst)
	
func _physics_process(delta):
	if $Timer.is_stopped():
		firemob_spawner(firingdir)
		$Timer.start()





func _on_Timer_timeout():
	$Timer.stop()

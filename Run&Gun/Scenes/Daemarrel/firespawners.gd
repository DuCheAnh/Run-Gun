extends Node2D

var firemob_waittime=0.5
var firemob=preload("res://Scenes/Southwold/mobs/FireMob.tscn")
export (int) var firingdir=-1
var case
var activated=false
func _ready():
	randomize()

func activate(c):
	if activated:
		if c<1:
			firemob_spawner(-1,$r1.position)
			firemob_spawner(1,$l1.position)
			firemob_spawner(-1,$r2.position)
			firemob_spawner(1,$l2.position)
		elif c<2:
			firemob_spawner(-1,$r1.position)
			firemob_spawner(1,$l1.position)
			firemob_spawner(-1,$r3.position)
			firemob_spawner(1,$l3.position)
		elif c<3:
			firemob_spawner(-1,$r2.position)
			firemob_spawner(1,$l2.position)
			firemob_spawner(-1,$r3.position)
			firemob_spawner(1,$l3.position)
func firemob_spawner(dir,pos):
		var inst=firemob.instance()
		inst.dir=dir
		inst.position=pos
		add_child(inst)
	
func _physics_process(delta):
	if $Timer.is_stopped():
		activate(case)
		$Timer.start()





func _on_Timer_timeout():
	$Timer.stop()


func _on_Kraken_fire():
	activated=true
	case=rand_range(0,3)


func _on_Kraken_summon():
	activated=false

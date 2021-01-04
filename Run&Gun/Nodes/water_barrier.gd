extends Area2D

signal barrier_destroyed
func _ready():
	_on_Player_close_barrier()

func _on_water_barrier_body_entered(body):
	if not "Player" in body.name and !$CollisionShape2D.disabled:
		print(body.name)
	


func _on_Player_init_barrier():
	visible=true
	$CollisionShape2D.disabled=false
	$CollisionShape2D.set_deferred("disabled",false)



func _on_Player_close_barrier():
	visible=false
	$CollisionShape2D.disabled=true
	$CollisionShape2D.set_deferred("disabled",true)



func _on_water_barrier_area_entered(area):
	if "FireBall" in area.name:
		_on_Player_close_barrier()
		emit_signal("barrier_destroyed")

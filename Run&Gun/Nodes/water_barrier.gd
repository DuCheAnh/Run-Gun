extends Area2D

signal barrier_destroyed
func _ready():
	_on_Player_close_barrier()


	


func _on_Player_init_barrier():
	visible=true
	$CollisionShape2D.disabled=false
	$CollisionShape2D.set_deferred("disabled",false)



func _on_Player_close_barrier():
	visible=false
	$CollisionShape2D.disabled=true
	$CollisionShape2D.set_deferred("disabled",true)



func _on_water_barrier_area_entered(area):
	if area.is_in_group("PlayerElements"):
		_on_Player_close_barrier()
		emit_signal("barrier_destroyed")

		
func _on_water_barrier_body_entered(body):
	if body.is_in_group("Enemies"):
		_on_Player_close_barrier()
		emit_signal("barrier_destroyed")
	
	


func _on_guard_init_barrier():
	_on_Player_init_barrier()


func _on_KingAuthur_init_barrier():
	_on_Player_init_barrier()

extends Area2D

signal barrier_destroyed
func _ready():
	_on_Player_close_barrier()

export (int) var damage = 3
	


func _on_Player_init_barrier():
	visible=true
	$up.play()
	$CollisionShape2D.disabled=false
	$CollisionShape2D.set_deferred("disabled",false)



func _on_Player_close_barrier():
	visible=false
	$down.play()
	$CollisionShape2D.disabled=true
	$CollisionShape2D.set_deferred("disabled",true)



func _on_water_barrier_area_entered(area):
	if area.is_in_group("Mob"):
		print(area.name)
		area.damage(damage)
		_on_Player_close_barrier()
		emit_signal("barrier_destroyed")
	if area.is_in_group("MobsAttack"):
		_on_Player_close_barrier()
		emit_signal("barrier_destroyed")
	pass

		
func _on_water_barrier_body_entered(body):
	if body.is_in_group("Mob"):
		body.damage(damage)
		_on_Player_close_barrier()
		emit_signal("barrier_destroyed")
	
	


func _on_guard_init_barrier():
	_on_Player_init_barrier()


func _on_KingAuthur_init_barrier():
	_on_Player_init_barrier()

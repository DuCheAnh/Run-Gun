extends Area2D

var velocity=Vector2()
var direction
var damage = 1
export (int) var firing_speed=100
const fireball_particle=preload("res://Nodes/FireballParticles.tscn")
func set_direction(isleft):
	if isleft:
		direction=-1
		$AnimatedSprite.flip_h=true
		if sign($CollisionShape2D.position.x)==1:
			$CollisionShape2D.position.x*=-1
	else:
		if sign($CollisionShape2D.position.x)==-1:
			$CollisionShape2D.position.x*=-1
		direction=1
		$AnimatedSprite.flip_h=false

func _physics_process(delta):
	velocity.x=firing_speed*delta*direction
	translate(velocity)
	$AnimatedSprite.play("Shooting")
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func destroy_fireball():
	var particle=fireball_particle.instance()
	particle.get_node(".").emitting=true
	particle.position=position
	get_tree().root.add_child(particle)
	queue_free()
func _on_FireBall_body_entered(body):
	if body.is_in_group("Mob"):
		body.damage(damage)
	if "Player" in body.name:
		print("fireball hit player")
	destroy_fireball()
	pass



func _on_FireBall_area_entered(area):
	if area.is_in_group("ElementsStopper"):	
		destroy_fireball()
	if area.is_in_group("Mob"):
		area.damage(damage)
		destroy_fireball()
		
	



extends Area2D

var velocity=Vector2()
var direction
export (int) var firing_speed=200
func set_direction(isleft):
	if isleft:
		direction=-1
		$AnimatedSprite.flip_h=true
	else:
		direction=1
		$AnimatedSprite.flip_h=false

func _physics_process(delta):
	velocity.x=firing_speed*delta*direction
	translate(velocity)
	$AnimatedSprite.play("Shooting")
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_FireBall_body_entered(body):
	if "Player" in body.name:
			#body.tabbed()
			pass


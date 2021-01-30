extends KinematicBody2D

var speed=1500
var spike_damage=2
var max_speed=2000
var jump_power=7000
var flr=Vector2(0,-1)
var dir=1
var gravity=520
var velocity=Vector2()
var chasing=false
var player
var particle=preload("res://Scenes/ExplosiveParticle.tscn")
export (int) var health=2
func _ready():
	set_physics_process(false)
	$Timer.stop()
func _physics_process(delta):
	velocity.y+=gravity*delta
	if !chasing:
		velocity.x=speed*dir*delta
	elif chasing:
		if is_on_floor() and $Timer.is_stopped():
			velocity.y-=jump_power*delta
			$Timer.start()
		velocity.x=(position.direction_to(player.position)*max_speed*delta).x
		if sign(velocity.x)<0:
			$AnimatedSprite.flip_h=true
		else:
			$AnimatedSprite.flip_h=false
	velocity=move_and_slide(velocity,flr)
	if $RayCast2D.is_colliding():
		dir*=-1
		$RayCast2D.cast_to.x*=-1
		if dir==-1:
			$AnimatedSprite.flip_h=true
		else:
			$AnimatedSprite.flip_h=false
func _on_Timer_timeout():
	$Timer.stop()
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player=body
		chasing=true

func damage(value):
	health-=value
	$AudioStreamPlayer2D.play()
	if health<=0:
		dead(20)
		queue_free()

func dead(amount):
	var inst=particle.instance()
	inst.amount=amount
	inst.get_node(".").emitting=true
	inst.position=position
	get_tree().root.add_child(inst)

func _on_Hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(spike_damage)

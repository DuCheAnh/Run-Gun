extends KinematicBody2D

var health=3
var speed = 1500
var max_speed=6000
var jump_power=8000
var gravity=520
var tooclose=false
var velocity=Vector2()
var player
var angry=false
var firemob=preload("res://Scenes/Southwold/mobs/FireMob.tscn")
var dir=-1
var flr=Vector2(0,-1)
var particle=preload("res://Scenes/ExplosiveParticle.tscn")
func dead(amount):
	var inst=particle.instance()
	inst.amount=amount
	inst.get_node(".").emitting=true
	inst.position=position
	get_tree().root.add_child(inst)
func _ready():
	$RayCast2D.cast_to*=dir
	pass
	
func _physics_process(delta):
	if !angry:
		$AnimatedSprite.play("default")
		if dir!=1:
			$AnimatedSprite.flip_h=true
		else:
			$AnimatedSprite.flip_h=false
		if sign($Position2D.position.x)!=dir:
			$Position2D.position.x*=-1
		if tooclose:
			velocity.x=-(position.direction_to(player.position)*max_speed*delta).x
			dir=sign(velocity.x)
		else:
			velocity.x=speed*dir*delta
		if sign($RayCast2D.cast_to.x)!=dir:
			$RayCast2D.cast_to.x*=-1
		if $RayCast2D.is_colliding():
			$RayCast2D.cast_to.x*=-1
			dir*=-1
	else:
		if sign($Position2D.position.x)!=sign((position.direction_to(player.position)).x):
				$Position2D.position*=-1
		$AnimatedSprite.play("shoot")
		if sign($Position2D.position.x)==-1:
			$AnimatedSprite.flip_h=true
		else:
			$AnimatedSprite.flip_h=false
		var inst=firemob.instance()
		inst.dir=sign($Position2D.position.x)
		inst.position=$Position2D.global_position
		get_parent().add_child(inst)
		angry=false
		$Position2D.position*=-1

	velocity.y+=gravity*delta
	move_and_slide(velocity,flr)
func _on_Sight_body_entered(body):
	if body.is_in_group("Player"):
		tooclose=true
		player=body

func damage(value):
	$AudioStreamPlayer2D.play()
	health-=value
	if health<=0:
		dead(20)
		queue_free()
func _on_Sight_body_exited(body):
	if body.is_in_group("Player"):
		angry=true
		yield(get_tree().create_timer(0.5),"timeout")
		tooclose=false

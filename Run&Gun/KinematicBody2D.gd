extends KinematicBody2D

var health=25
var chop_damage=3
var multiplier=3
var speed=2000
var gravity=520
var flr=Vector2(0,-1)
var attacking
var walking
var slamming
var died
var dir
var player
var player_hit=false
signal dead
var velocity=Vector2()
var particle=preload("res://Scenes/ExplosiveParticle.tscn")
func dead(amount):
	var inst=particle.instance()
	inst.amount=amount
	inst.get_node(".").emitting=true
	inst.position=position
	get_tree().root.add_child(inst)
func _ready():
	dir=1
	pass

func damage(value):
	
	$hit.play()
	health-=value
	if health<=0:
		gravity=0
		dead(50)
		$explode.play()
		$AnimatedSprite.visible=false
		$CollisionShape2D.disabled=true
		set_physics_process(false)
		yield($explode,"finished")
		emit_signal("dead")
		queue_free()

func _physics_process(delta):
	if !$explode.playing:
		if player!=null:
			dir=sign(position.direction_to(player.position).x)
			if $RayCast2D.is_colliding(): 
				var c=$RayCast2D.get_collider()
				if c.name=="Player":
					chop(delta)
			else:
				moving(delta)
		else:
			idle()
			player_hit=false
		if dir<0:
			if $RayCast2D.cast_to.x>0:
				$RayCast2D.cast_to*=-1
				if $ChopArea/CollisionShape2D.position.x>0:
					$ChopArea/CollisionShape2D.position.x*=-1
			$AnimatedSprite.flip_h=true
		else:
			if $RayCast2D.cast_to.x<0:
				$RayCast2D.cast_to*=-1
				if $ChopArea/CollisionShape2D.position.x<0:
					$ChopArea/CollisionShape2D.position.x*=-1
			$AnimatedSprite.flip_h=false
			
		velocity.y+=gravity*delta
		move_and_slide(velocity,flr)
func moving(delta):
	$AnimatedSprite.play("walk")
	velocity.x=dir*speed*delta
	pass

func slamming(delta):
	$AnimatedSprite.play("attack2")
	velocity.x=dir*speed*delta*multiplier

func chop(delta):
	if gravity!=0:
		$AnimatedSprite.play("attack1")
		$ChopArea/CollisionShape2D.disabled=false

func idle():
	$AnimatedSprite.play("idle")
	

func _on_Sight_body_entered(body):
	if body.is_in_group("Player"):
		player=body
func _on_Sight_body_exited(body):
	if body.is_in_group("Player"):
		player=null



func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(chop_damage)
		pass


func _on_AnimatedSprite_animation_finished():
	$ChopArea/CollisionShape2D.disabled=true

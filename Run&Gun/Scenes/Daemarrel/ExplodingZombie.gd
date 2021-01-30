extends KinematicBody2D

var health=3
var chop_damage=3
var multiplier=3
var speed=3000
var gravity=520
var flr=Vector2(0,-1)
var attacking
var walking
var slamming
var died
var dir
var player
var player_hit=false
var sub_player=null
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

func explode():
	$RayCast2D.enabled=false
	speed=0
	$Tween.interpolate_property($AnimatedSprite,"modulate",Color(1,1,1,1),Color(1,0,0,1),0.25,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	damage(20)
	pass
func damage(value):
	$hit.play()
	health-=value
	if health<=0:
		gravity=0
		dead(50)
		if !$explode.playing:
			$explode.play()
		$AnimatedSprite.visible=false
		$CollisionShape2D.disabled=true
		set_physics_process(false)
		yield($explode,"finished")
		if sub_player!=null:
			sub_player.damage(10)
		queue_free()

func _physics_process(delta):
	if !$explode.playing:
		if player!=null:
			dir=sign(position.direction_to(player.position).x)
			if $RayCast2D.is_colliding(): 
				var c=$RayCast2D.get_collider()
				if c.name=="Player":
					explode()
			else:
				moving(delta)
		else:
			idle()
		if dir<0:
			if $RayCast2D.cast_to.x>0:
				$RayCast2D.cast_to*=-1
			$AnimatedSprite.flip_h=true
		else:
			if $RayCast2D.cast_to.x<0:
				$RayCast2D.cast_to*=-1
			$AnimatedSprite.flip_h=false


		velocity.y+=gravity*delta
		velocity=move_and_slide(velocity,flr)
func moving(delta):
	$AnimatedSprite.play("walk")
	velocity.x=dir*speed*delta
	pass



func idle():
	$AnimatedSprite.play("idle")
	

func _on_Sight_body_entered(body):
	if body.is_in_group("Player"):
		player=body
func _on_Sight_body_exited(body):
	if body.is_in_group("Player"):
		player=null
	


func _on_boomarea_body_entered(body):
	if body.is_in_group("Player"):
		sub_player=body


func _on_boomarea_body_exited(body):
	if body.is_in_group("Player"):
		sub_player=null

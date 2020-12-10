extends KinematicBody2D

#variables
export (float) var speed_value = 2
export (float) var max_speed_value = 6
export (float) var jump_value = 12
export (float) var dash_value = 25
export (int) var gravity_value = 520
export (float) var dash_wait_time = 0.15
export (int) var dash_charge_value = 1
export (float) var acceleration_value = 0.5
export (float) var bullet_wait_time = 0.2
export (int) var default_bullet_count = 100
#actual variables in use
var velocity = Vector2()
var Floor = Vector2(0,-1)
const fireball_preload=preload("res://Nodes/FireBall.tscn")
var speed
var jump_speed
var dash_speed
var gravity
var post_gravity
var dash_charges
var direction
var acceleration
var de_acceleration
var bullet_count
func _ready():
	speed=speed_value
	jump_speed=jump_value
	dash_speed=dash_value
	gravity=gravity_value
	post_gravity=gravity*1.5
	dash_charges=dash_charge_value
	direction=1
	acceleration=acceleration_value
	de_acceleration=acceleration_value*2
	bullet_count=default_bullet_count

#functions
func _physics_process(delta):
	action_process(delta)
	render_process()
		
func action_process(var delta):
	var multiplier=1000 #multiplying the numbers 
	move_and_jump(multiplier,delta)
	charges_reset()
	if Input.is_action_pressed("shoot"):
		Shoot()
	if Input.is_action_just_pressed("dash") and dash_charges>0:
		Dash()
	if is_on_ceiling():
		velocity.y=0;
	#convert to velocity(x,y)
	velocity.x=direction*multiplier*speed*delta
	velocity.y+=gravity*delta
	#aplly movements to scene
	move_and_slide (velocity,Floor)

func render_process():
	if Input.is_action_pressed("ui_right") and is_on_floor():
		$AnimatedSprite.play("default")
		$AnimatedSprite.flip_h=false
		if sign($ShootingPosition.position.x)==-1:
			$ShootingPosition.position.x*=-1
	elif Input.is_action_pressed("ui_left") and is_on_floor():
		$AnimatedSprite.play("default")
		$AnimatedSprite.flip_h=true
		if sign($ShootingPosition.position.x)==1:
			$ShootingPosition.position.x*=-1
	if not $Timer.is_stopped():		
		var ghost_inst=preload("res://Nodes/Ghost.tscn").instance()
		get_parent().add_child(ghost_inst)
		ghost_inst.position=position
		ghost_inst.texture=$AnimatedSprite.frames.get_frame($AnimatedSprite.animation,$AnimatedSprite.frame)
		ghost_inst.flip_h=$AnimatedSprite.flip_h


func move_and_jump(multiplier,delta):
	if $Timer.is_stopped():
		if Input.is_action_pressed("ui_right"):
			direction=1
			speed+=acceleration
		elif Input.is_action_pressed("ui_left"):
			speed+=acceleration
			direction=-1
		else:
			if speed>speed_value: speed-=de_acceleration
			else: 
				speed=speed_value
				direction=0
		if speed>=max_speed_value: 
			speed=max_speed_value
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y=-multiplier*jump_speed*delta
		if Input.is_action_just_pressed("ui_up") and !is_on_floor():
			pass
		if sign(velocity.y)<0:
			gravity=gravity_value
		else:
			gravity=post_gravity

	
#Dashing+Shooting
func Dash():
	dash_charges-=1
	gravity=0
	speed=dash_speed
	#velocity.y=-1000*speed*delta
	$Timer.wait_time=dash_wait_time
	$Timer.start()

func Shoot():
	if $ShootTimer.is_stopped() && bullet_count>0:
		var fireball=fireball_preload.instance()
		fireball.set_direction($AnimatedSprite.flip_h)
		get_parent().add_child(fireball)
		fireball.position=$ShootingPosition.global_position
		bullet_count-=1
		$ShootTimer.wait_time=bullet_wait_time
		$ShootTimer.start()

func charges_reset():
	if is_on_floor():
		dash_charges=dash_charge_value	

#Timer out
func _on_Timer_timeout():
	speed=speed_value
	gravity=gravity_value
	$Timer.stop()


func _on_ShootTimer_timeout():
	$ShootTimer.stop()

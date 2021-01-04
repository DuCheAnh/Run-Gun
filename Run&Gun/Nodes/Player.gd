extends KinematicBody2D

#variables
export (float) var speed_value = 2
export (float) var max_speed_value = 4
export (float) var jump_value = 10
export (float) var dash_value = 15
export (int) var gravity_value = 520
export (float) var dash_wait_time = 0.15
export (int) var dash_charge_value = 1
export (float) var acceleration_value = 0.5
export (float) var bullet_wait_time = 0.3
export (int) var default_bullet_count = 100
#actual variables in use
var velocity = Vector2()
var Floor = Vector2(0,-1)
const fireball_preload=preload("res://Nodes/FireBall.tscn")
const barrier_preload=preload("res://Nodes/water_barrier.tscn")
signal close_barrier
signal init_barrier
var barrier_counter=5
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
var casting=false
var current_form
var ani_run
var ani_jump
var ani_idle
var ani_fall
var ani_cast
var form_counter=0
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
	#setting up ani
	current_form="basic"
	

#functions
func _physics_process(delta):
	action_process(delta)
	render_process()
		
func action_process(var delta):
	var multiplier=1000 #multiplying the numbers 
	move_and_jump(multiplier,delta)
	charges_reset()
	if Input.is_action_just_pressed("shoot"):
		if current_form=="fire":
			Shoot()
		elif current_form=="water":
			$WaterSwordArea/SwordCollision.disabled=false
			pass
	if Input.is_action_just_pressed("dash") and dash_charges>0:
		if current_form=="electric":
			Dash()
		elif current_form=="water":
			Barrier()
			pass
	if is_on_ceiling():
		velocity.y=0;
	#convert to velocity(x,y)
	velocity.x=direction*multiplier*speed*delta
	velocity.y+=gravity*delta
	#aplly movements to scene
	velocity=move_and_slide(velocity,Floor)

func switch_form():
	form_counter+=1
	if form_counter>3:
		form_counter=0
	if form_counter==0:
		current_form="basic"
	elif form_counter==1:
		current_form="fire"
	elif form_counter==2:
		current_form="water"
	elif form_counter==3:
		current_form="electric"
func set_ani():
	if current_form=="fire":
		ani_cast="fire_cast"
		ani_fall="fire_fall"
		ani_idle="fire_idle"
		ani_jump="fire_jump"
		ani_run="fire_run"
	elif current_form=="water":
		ani_cast="water_splash"
		ani_fall="water_fall"
		ani_idle="water_idle"
		ani_jump="water_jump"
		ani_run="water_run"
	elif current_form=="electric":
		ani_cast="electric_cast"
		ani_fall="electric_fall"
		ani_idle="electric_idle"
		ani_jump="electric_jump"
		ani_run="electric_run"
	else:
		ani_cast="basic_cast"
		ani_fall="basic_fall"
		ani_idle="basic_idle"
		ani_jump="basic_jump"
		ani_run="basic_run"

func render_process():
	if Input.is_action_just_pressed("change_form"):
		switch_form()
	set_ani()
	#fliping sprites
	if Input.is_action_pressed("ui_right") and !casting:
		$AnimatedSprite.flip_h=false
		if sign($WaterSwordArea/SwordCollision.position.x)==-1:
			$WaterSwordArea/SwordCollision.position.x*=-1
		if sign($ShootingPosition.position.x)==-1:
				$ShootingPosition.position.x*=-1
		$Particles2D.position.x=-3
	elif Input.is_action_pressed("ui_left") and !casting:
		if sign($ShootingPosition.position.x)==1:
			$ShootingPosition.position.x*=-1
		if sign($WaterSwordArea/SwordCollision.position.x)==1:
			$WaterSwordArea/SwordCollision.position.x*=-1
		$Particles2D.position.x=3
		$AnimatedSprite.flip_h=true
	#changing animations
	if Input.is_action_pressed("ui_right") and is_on_floor() and !casting:
		$AnimatedSprite.play(ani_run)
	elif Input.is_action_pressed("ui_left") and is_on_floor() and !casting:
		$AnimatedSprite.play(ani_run)
	else:
		if casting==false && is_on_floor():
			$AnimatedSprite.play(ani_idle)
	if !is_on_floor():
		if sign(velocity.y)<0:
			$AnimatedSprite.play(ani_jump)
		else:
			$AnimatedSprite.play(ani_fall)
	#ghosting dash
	if not $Timer.is_stopped():		
		var ghost_inst=preload("res://Nodes/Ghost.tscn").instance()
		get_parent().add_child(ghost_inst)
		ghost_inst.position=position
		ghost_inst.texture=$AnimatedSprite.frames.get_frame($AnimatedSprite.animation,$AnimatedSprite.frame)
		ghost_inst.flip_h=$AnimatedSprite.flip_h
	if Input.is_action_just_pressed("shoot"):
		$AnimatedSprite.play(ani_cast)
		casting=true
		
	if $AnimatedSprite.animation!=ani_idle and is_on_floor() and !casting:
		$Particles2D.emitting=true
	else:
		$Particles2D.emitting=false
func move_and_jump(multiplier,delta):
	if $Timer.time_left<dash_wait_time/5:
		if Input.is_action_pressed("ui_right") and !casting:
			direction=1
			speed+=acceleration
		elif Input.is_action_pressed("ui_left") and !casting:
			speed+=acceleration
			direction=-1
		else:
			if speed>speed_value: speed-=de_acceleration
			else: 
				speed=speed_value
				direction=0
		if speed>=max_speed_value: 
			speed=max_speed_value
		if Input.is_action_just_pressed("ui_up") and is_on_floor() and !casting:
			velocity.y=-multiplier*jump_speed*delta
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

func Barrier():
	if $WaterBarrier.visible:
		emit_signal("close_barrier")
	elif barrier_counter>0:
		emit_signal("init_barrier")

	pass
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

func _on_AnimatedSprite_animation_finished():
		casting=false
		$WaterSwordArea/SwordCollision.disabled=true


func _on_water_barrier_barrier_destroyed():
	pass
	

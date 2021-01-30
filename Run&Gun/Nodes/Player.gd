extends KinematicBody2D

#variables
export (float) var speed_value = 1.5
export (float) var max_speed_value = 3
export (float) var jump_value = 10
export (float) var dash_value = 15
export (int) var gravity_value = 520
export (float) var dash_wait_time = 0.15
export (int) var dash_charge_value = 1
export (float) var acceleration_value = 0.5
export (float) var bullet_wait_time = 0.3
export (int) var current_health
export (int) var current_mana
export (int) var bullet_mana=1
export (int) var dash_mana=5
export (int) var barrier_mana=5
export (int) var splash_mana=1
#actual variables in use
var max_health
var max_mana
var velocity = Vector2()
var Floor = Vector2(0,-1)
const fireball_preload=preload("res://Nodes/FireBall.tscn")
const barrier_preload=preload("res://Nodes/water_barrier.tscn")
signal close_barrier
signal init_barrier
signal mana_changed
signal set_max_mana
signal set_max_health
signal health_changed
signal form_changed
signal is_dead
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
	set_max_mana(20)
	set_mana(0)
	set_max_health(20)
	set_health(20)
	#setting up ani
	current_form="basic"
	emit_signal("form_changed",current_form)
#functions
func _physics_process(delta):
	action_process(delta)
	render_process()
	if Input.is_action_just_pressed("ui_focus_next"):
		$Light2D.visible=!$Light2D.visible
func action_process(var delta):
	var multiplier=1000 #multiplying the numbers 
	move_and_jump(multiplier,delta)
	charges_reset()
	if Input.is_action_just_pressed("shoot"):
		if current_form=="fire":
			Shoot()
		elif current_form=="basic" and is_on_floor():
			Splash()
			pass
		if current_form=="electric" and dash_charges>0:
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
		$ExplosiveParticle.process_material.color=Color("d4dbdc")
		$ExplosiveParticle.emitting=true
	elif form_counter==1:
		current_form="fire"
		$ExplosiveParticle.process_material.color=Color("f25a48")
		$ExplosiveParticle.emitting=true
	elif form_counter==2:
		current_form="water"
		$ExplosiveParticle.process_material.color=Color("639bff")
		$ExplosiveParticle.emitting=true
	elif form_counter==3:
		current_form="electric"
		$ExplosiveParticle.process_material.color=Color("f2ea62")
		$ExplosiveParticle.emitting=true
	$Shake.screen_shake(0.2,0.5,200)
	$Audios/ChangeForm.play()
	emit_signal("form_changed",current_form)
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
		ani_cast="water_splash"
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
		if casting:
			$AnimatedSprite.play(ani_cast)
		
	if $AnimatedSprite.animation!=ani_idle and is_on_floor() and !casting:
		$Particles2D.emitting=true
	else:
		$Particles2D.emitting=false
func move_and_jump(multiplier,delta):
	if $Timer.time_left<dash_wait_time/5:
		if Input.is_action_pressed("ui_right") and !casting:
			if !$Audios/Walk.playing and is_on_floor():
				$Audios/Walk.play()
			direction=1
			speed+=acceleration
		elif Input.is_action_pressed("ui_left") and !casting:
			if !$Audios/Walk.playing and is_on_floor():
				$Audios/Walk.play()
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
			$Audios/Jump.play()
		if sign(velocity.y)<0:
			gravity=gravity_value
		else:
			gravity=post_gravity
#normals and specials
func Dash():
	if consume_mana(dash_mana):
		dash_charges-=1
		gravity=0
		speed=dash_speed
		$Audios/Dash.play()
		#velocity.y=-1000*speed*delta
		$Timer.wait_time=dash_wait_time
		$Timer.start()
func Shoot():
	if $ShootTimer.is_stopped() and consume_mana(1):
		$Shake.screen_shake(0.2,0.3,200)
		casting=true
		var fireball=fireball_preload.instance()
		fireball.set_direction($AnimatedSprite.flip_h)
		get_parent().add_child(fireball)
		fireball.position=$ShootingPosition.global_position
		$Audios/Shoot.play()
		$ShootTimer.wait_time=bullet_wait_time
		$ShootTimer.start()
func Splash():
	if consume_mana(splash_mana):
		$Audios/Chop.play()
		casting=true
		$WaterSwordArea/SwordCollision.disabled=false
func Barrier():
	if $WaterBarrier.visible:
		consume_mana(-barrier_mana)
		emit_signal("close_barrier")
	elif consume_mana(barrier_mana):
		emit_signal("init_barrier")

func charges_reset():
	if is_on_floor():
		dash_charges=dash_charge_value	

#Mana and heatlh
func restore_health(value):
	set_health(current_health+value)
func restore_mana(value):
	set_mana(current_mana+value)
func set_max_mana(value):
	max_mana=max(1,value)
	emit_signal("set_max_mana",max_mana)
func set_max_health(value):
	max_health=max(1,value)
	emit_signal("set_max_health",max_health)
func set_health(value):
	current_health=clamp(value,0,max_health)
	emit_signal("health_changed",current_health)
func set_mana(value):
	current_mana=clamp(value,0,max_mana)
	emit_signal("mana_changed",current_mana)
func consume_mana(value)-> bool:
	if (current_mana-value>=0):
		set_mana(current_mana-value)
		return true
	else:
		return false	
func damage(value):
	$Audios/Hit.play()
	$Shake.screen_shake(0.2,0.4,200)
	set_health(current_health-value)
	if current_health==0:
		dies()
func dies():
	$Shake.screen_shake(0.5,1,300)
	if !$Audios/Dies.playing:
		$Audios/Dies.play()
	$AnimatedSprite.visible=false
	$ExplosiveParticle.emitting=true
	set_physics_process(false)
	yield(get_tree().create_timer(0.2),"timeout")
	emit_signal("is_dead")
	pass
#Timer out
func _on_Timer_timeout():
	speed=speed_value
	gravity=gravity_value
	$Timer.stop()
func _on_ShootTimer_timeout():
	$ShootTimer.stop()
#signals
func _on_AnimatedSprite_animation_finished():
		casting=false
		$WaterSwordArea/SwordCollision.disabled=true
func _on_water_barrier_barrier_destroyed():
	barrier_counter-=1
	print(barrier_counter)
	pass
	





	


func _on_Kraken_destroy():
	damage(20)

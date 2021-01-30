extends Area2D

var speed=50
var spike_damage=5
var health=2
export (int) var dir=1
var particle=preload("res://Scenes/ExplosiveParticle.tscn")
func dead(amount):
	var inst=particle.instance()
	inst.amount=amount
	inst.get_node(".").emitting=true
	inst.position=position
	get_tree().root.add_child(inst)
func _ready():
	if dir==-1:
		$AnimatedSprite.flip_h=true
	pass

func _physics_process(delta):
	position.x+=dir*speed*delta
	


func _on_Timer_timeout():
	dead(20)
	queue_free()

func damage(value):
	$AudioStreamPlayer2D.play()
	health-=value
	if health<=0:
		dead(20)
		queue_free()

func _on_FireMob_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(spike_damage)
		queue_free()



func _on_FireMob_area_entered(area):
#	if area.is_in_group("PlayerElements"):
#		damage(area.damage)
	pass

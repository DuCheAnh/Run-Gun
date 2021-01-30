extends KinematicBody2D

var health=20
signal fire
signal summon
signal destroy
signal dead
var particle=preload("res://Scenes/ExplosiveParticle.tscn")
func damage(value):
	health-=value
	$AudioStreamPlayer2D.play()
	if health<=0:
		dead(20)
		emit_signal("dead")
		queue_free()

func dead(amount):
	var inst=particle.instance()
	inst.amount=amount
	inst.get_node(".").emitting=true
	inst.position=position
	get_tree().root.add_child(inst)

func _ready():
	randomize()
	$Timer.start()
	$Timer2.start()


func _on_Timer_timeout():
	var c=rand_range(0,1)
	if c<1:
		emit_signal("fire")
		print("fire")
	else:
		emit_signal("summon")
		print("else")


func _on_Timer2_timeout():
	$AnimatedSprite.play("attack")
	yield($AnimatedSprite,"animation_finished")
	emit_signal("destroy")


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		$AnimatedSprite.play("attack")
		body.damage(20)

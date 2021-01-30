extends Area2D

var speed=0.5
var dir=Vector2()
var player
var spike_damage = 3
var health=1
var particle=preload("res://Scenes/ExplosiveParticle.tscn")
func dead(amount):
	var inst=particle.instance()
	inst.amount=amount
	inst.get_node(".").emitting=true
	inst.position=position
	get_tree().root.add_child(inst)
func _physics_process(delta):
	if player!=null:
		position+=position.direction_to(player.global_position)*speed

	


func _on_Sight_body_entered(body):
	if body.is_in_group("Player"):
		player=body

func _on_Sight_body_exited(body):
	if body.is_in_group("Player"):
		player=null

func damage(value):
	health-=value
	$AudioStreamPlayer2D.play()
	if health<=0:
		dead(20)
		queue_free()
func _on_Bird_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(spike_damage)
		$CollisionShape2D.disabled=true
		dead(20)
		queue_free()

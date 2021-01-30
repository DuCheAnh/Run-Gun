extends Area2D


var player=null


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.stop()


func _physics_process(delta):
	if $Timer.is_stopped():
		if player!=null:
			$Timer.start()
		

func _on_icespike_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(2)
		player=body



func _on_icespike_body_exited(body):
	if body.is_in_group("Player"):
		player=null


func _on_Timer_timeout():
	$Timer.stop()
	if (player!=null):
		_on_icespike_body_entered(player)

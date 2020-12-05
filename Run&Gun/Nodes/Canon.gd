extends StaticBody2D

const fireball_pre= preload("res://Nodes/FireBall.tscn")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var fireball= fireball_pre.instance()
		fireball.set_direction(true)
		fireball.position=$Position2D.global_position
		get_parent().add_child(fireball)
		
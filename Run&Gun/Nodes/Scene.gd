extends Node2D

func _process(delta):
	var b_count=$Player.bullet_count as String
	$CanvasLayer/Label.text="Bullet: " + b_count

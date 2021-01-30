extends Area2D


var broken=false


func _on_LesserCrystalDisk_body_entered(body):
	if body.is_in_group("Player") and !broken:
		$AudioStreamPlayer2D.play()
		body.restore_mana(10)
		broken=true
		$AnimatedSprite.play("empty")


func _on_LesserCrystalDisk_body_exited(body):
	if body.is_in_group("Player"):
		yield(get_tree().create_timer(1),"timeout")
		broken=false
		$AnimatedSprite.play("default")

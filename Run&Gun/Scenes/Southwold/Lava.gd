extends Area2D


func _on_Lava_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Mob"):
		$AudioStreamPlayer.play()
		body.damage(999)

func _on_Lava_area_entered(area):
	if area.is_in_group("Player") or area.is_in_group("Mob"):
		$AudioStreamPlayer.play()
		area.damage(999)

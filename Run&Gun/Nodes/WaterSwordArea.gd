extends Area2D


export (int) var damage = 2



func _on_WaterSwordArea_area_entered(area):
	if area.is_in_group("Mob"):
		area.damage(damage)


func _on_WaterSwordArea_body_entered(body):
	if body.is_in_group("Mob"):
		body.damage(damage)

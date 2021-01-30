extends Area2D


func _ready():
	$AnimatedSprite.play("closed")



func _on_Chest_body_entered(body):
	if body.is_in_group("Player"):
		$AnimatedSprite.play("opened")


func _on_Chest_body_exited(body):
	if body.is_in_group("Player"):
		$AnimatedSprite.play("closed")

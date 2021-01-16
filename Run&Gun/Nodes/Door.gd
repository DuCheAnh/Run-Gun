extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (bool) var flip_h =false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("closed")
	$AnimatedSprite.flip_h=flip_h
	if (flip_h):
		$CollisionShape2D.position.x=3
		$AnimatedSprite.position.x=-2
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		$AnimatedSprite.play("opened")


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		$AnimatedSprite.play("closed")

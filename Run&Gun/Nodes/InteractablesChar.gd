extends Area2D

export (Texture) var CharSprite
export (String) var message
signal init_dialog
func _ready():
	$Sprite.texture=CharSprite



func _on_InteractablesChar_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("init_dialog",message)


func _on_InteractablesChar_body_exited(body):
	if body.is_in_group("Player"):
		$DialogBubble.visible=false

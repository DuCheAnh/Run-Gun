extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal init_barrier
signal close_barrier
signal init_dialog
export (String) var message

func _on_KingAuthur_area_entered(area):
	if area.is_in_group("PlayerElements"):
		emit_signal("init_barrier")


func _on_KingAuthur_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("init_dialog",message)


func _on_KingAuthur_body_exited(body):
	if body.is_in_group("Player"):
		$DialogBubble.visible=false

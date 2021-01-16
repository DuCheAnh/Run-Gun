extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal init_barrier
signal close_barrier
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_KingAuthur_area_entered(area):
	if area.is_in_group("PlayerElements"):
		emit_signal("init_barrier")


func _on_KingAuthur_body_entered(body):
	if body.is_in_group("Player"):
		print("hello player")

extends Area2D


signal init_barrier
signal close_barrier


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_guard_body_entered(body):
	if body.is_in_group("Player"):
		print("hello player")


func _on_guard_area_entered(area):
	if area.is_in_group("PlayerElements"):
		emit_signal("init_barrier")

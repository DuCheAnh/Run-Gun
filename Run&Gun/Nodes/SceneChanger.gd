extends CanvasLayer

var scene

func _change_to_scene(path):
	scene=path
	$Control/AnimationPlayer.play("laod")

func _new_scene():
	get_tree().change_scene(scene)

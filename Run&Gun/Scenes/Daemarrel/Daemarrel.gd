extends Node2D




func _on_Player_is_dead():
	SceneChanger._change_to_scene("res://Scenes/Daemarrel/Daemarrel.tscn")


func _on_Portal_body_entered(body):
	if body.is_in_group("Player"):
		SceneChanger._change_to_scene("res://Scenes/Daemarrel/DardLordLair.tscn")

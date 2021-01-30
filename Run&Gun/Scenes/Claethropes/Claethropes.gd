extends Node2D

func _ready():
	Musicplayer.play_fighting()

func _on_Player_is_dead():
	SceneChanger._change_to_scene("res://Scenes/Claethropes/Claethropes.tscn")
	



func _on_Portal_body_entered(body):
	if body.is_in_group("Player"):
		SceneChanger._change_to_scene("res://Scenes/Daemarrel/Daemarrel.tscn")
		pass

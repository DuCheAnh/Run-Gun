extends Node2D

func _ready():
	setup(false)

func setup(value):
	$VictoryStairs.visible=value
	$VictoryStairs/VictoryStair/CollisionShape2D.disabled=!value
	$VictoryStairs/VictoryStair2/CollisionShape2D.disabled=!value

func _on_Player_is_dead():
	SceneChanger._change_to_scene("res://Scenes/Mountmend/Mountmend.tscn")


func _on_gumspawner_boss_finished():
	$Player/Cam.limit_right=1448
	setup(true)


func _on_Portal_body_entered(body):
	if body.is_in_group("Player"):
		SceneChanger._change_to_scene("res://Scenes/Claethropes/Claethropes.tscn")

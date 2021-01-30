extends Node2D

func _ready():
	$stairs.visible=false
	$stairs/VictoryStair/CollisionShape2D.disabled=true
	$stairs/VictoryStair2/CollisionShape2D.disabled=true
	Musicplayer.play_fighting2()

func _on_Portal_body_entered(body):
	if body.is_in_group("Player"):
		SceneChanger._change_to_scene("res://Scenes/Mountmend/Mountmend.tscn")



func _on_Player_is_dead():
	SceneChanger._change_to_scene("res://Scenes/Southwold/Southwold.tscn")


func _on_Butcher_dead():
	$stairs.visible=true
	$stairs/VictoryStair/CollisionShape2D.disabled=false
	$stairs/VictoryStair2/CollisionShape2D.disabled=false

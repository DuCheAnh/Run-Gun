extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	Musicplayer.play_boss()

# Called when the node enters the scene tree for the first time.
func _process(delta):
	$Label.text=String(int($Timer.time_left))
	if $Timer.time_left>10:
		$AnimatedSprite.play("default")
	else:
		$AnimatedSprite.play("deadly")


func _on_Player_is_dead():
	SceneChanger._change_to_scene("res://Scenes/Daemarrel/DardLordLair.tscn")


func _on_Kraken_dead():
	SceneChanger._change_to_scene("res://Scenes/Daemarrel/EndGame.tscn")

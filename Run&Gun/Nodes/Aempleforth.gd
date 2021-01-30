extends Node2D
var shown=false
func _ready():
	Musicplayer.play_town()

func _on_Portal_body_entered(body):
	if body.is_in_group("Player"):
		if body.current_mana==body.max_mana:
			SceneChanger._change_to_scene("res://Scenes/Southwold/Southwold.tscn")


func _on_CrystalDisk_body_entered(body):
	if !shown and body.is_in_group("Player"):
		shown=true
		get_tree().paused=true
		$PlayersUI/VideoPlayer.play()
		$PlayersUI/VideoPlayer.visible=true


func _on_VideoPlayer_finished():
	get_tree().paused=false
	$PlayersUI/VideoPlayer.visible=false

extends CanvasLayer



func _on_Player_set_max_mana(value):
	$Control/ManaBar/TextureProgress.max_value=value


func _on_Player_mana_changed(mana):
	$Tween.interpolate_property($Control/ManaBar/TextureProgress,"value",$Control/ManaBar/TextureProgress.value,mana,1,Tween.TRANS_ELASTIC,Tween.EASE_OUT)	
	$Tween.start()


func _on_Player_set_max_health(value):
	$Control/HealthBar/TextureProgress.max_value=value


func _on_Player_health_changed(health):
	$Tween.interpolate_property($Control/HealthBar/TextureProgress,"value",$Control/HealthBar/TextureProgress.value,health,1,Tween.TRANS_ELASTIC,Tween.EASE_OUT)	
	$Tween.start()

func _on_Player_form_changed(form):
	if form=="water":
		$Control/TextureRect.texture=load("res://Sprites/UI/WaterFormIcon..png")
		$attack/TextureRect.texture=load("res://Sprites/UI/waterball.png")
	elif form=="fire":
		$Control/TextureRect.texture=load("res://Sprites/UI/FireFormIcon..png")
		$attack/TextureRect.texture=load("res://Sprites/UI/fireballicon.png")
	elif form=="electric":
		$Control/TextureRect.texture=load("res://Sprites/UI/ElectricFormIcon..png")
		$attack/TextureRect.texture=load("res://Sprites/UI/electricicon.png")
	else:
		$Control/TextureRect.texture=load("res://Sprites/UI/BasicFormIcon..png")
		$attack/TextureRect.texture=load("res://Sprites/UI/watericon.png")
	pass


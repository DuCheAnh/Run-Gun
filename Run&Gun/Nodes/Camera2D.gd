extends Camera2D

#
#var limit_offset=0
#func _ready():
#
#	pass # Replace with function body.
#
#func trans_scene(val):
#	var distance=375
#	if distance*val+get_viewport_rect().size.x>limit_right:
#		limit_offset=distance*val+get_viewport_rect().size.x-limit_right
#	else:
#		limit_offset=0
#	$Tween.interpolate_property(self,"limit_left",limit_left,distance*val-limit_offset,0.1,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT)
#	$Tween.start()
#
#func _physics_process(delta):
#	var counter=int((get_parent().position.x+10)/375)
#	trans_scene(counter)
#
#func _on_Tween_tween_completed(object, key):
#	pass

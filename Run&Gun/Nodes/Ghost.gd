extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$aTween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,0.2,0),.15,Tween.TRANS_SINE,Tween.EASE_OUT)
	$aTween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_aTween_tween_completed(object, key):
	queue_free()


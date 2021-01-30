extends TextureRect


var speed
var activated=false

func _ready():
	visible=false
	pass
func activate(node_name,message):
	visible=true
	get_node(node_name).text=message
	get_node(node_name).visible=true
	$Tween.interpolate_property(get_node(node_name),"percent_visible",0,1,1,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start()


func _on_guard_init_dialog(message):
	activate("Guard",message)


func _on_KingAuthur_init_dialog(message):
	activate("King",message)


func _on_VisibilityNotifier2D_screen_exited():
	visible=false


func _on_InteractablesChar_init_dialog(message):
	activate("InteractableChar",message)
	pass

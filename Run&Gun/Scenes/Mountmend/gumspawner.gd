extends Node2D

var started=false
var stopped=false
var pre=preload("res://Scenes/Mountmend/BubbleGum.tscn")
var last_child_count=0
var original_child_count
signal boss_finished
func _ready():
	original_child_count=get_child_count()
func _physics_process(delta):
	original_child_count=2
	if get_child_count()-original_child_count>=2:
		stopped=true
	if stopped and get_child_count()==original_child_count:
		emit_signal("boss_finished")
	if (last_child_count!=0 and last_child_count!=get_child_count()):
		started=true
	if started and !stopped:
		for i in range(last_child_count+1-get_child_count()):
			var inst=pre.instance()
			inst.position=$Position2D.global_position
			inst.position.x+=(i-1)*8
			add_child(inst)
			started=false
		last_child_count=get_child_count()
	pass

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		started=true

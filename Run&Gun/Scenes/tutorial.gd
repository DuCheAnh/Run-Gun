extends Node2D

var a=[]
var count=0
var slime=preload("res://Scenes/Southwold/mobs/Slime.tscn")
var crystal=preload("res://Nodes/CrystalDisk.tscn")
var l1="Hello Magi, time to relearn your spell to prepare for the danger out there"
var l2="This is your Mana, it's crucial to your spells, without mana there's no using it"
var l2p2="Pick up these crystal to restore your mana"
var l3="Let's talk about your power"
var l4="You have 4 forms, which you can changes from one to another with Q"
var l5="Each form have a unique ability that can identify your playstyles"
var l6="The Basic form ability is -Energy Splash- it dealt moderate damage, it's very useful for offense and defense, since you can also cut down bullets from the enemy"
var l7="The Fire form ability is -Fireball- it dealt a small amount of damage, but it's range, suitable for circumstances where you wanted to be out of the enemy's reach"
var l9="The Electric form ability is -Lightningdash- it dealt no damage, but it's very suitable for fast traveling and speed running"
var l8="The Water form ability is -WaterBarrier-, it protects you from the next danger, it also dealt a high amount of damage when it bump into a mob"
var l10="That's it for now, try to use your power to your advantage Magi"
func _ready():
	
	a.append(l1)
	a.append(l2)
	a.append(l2p2)
	a.append(l3)
	a.append(l4)
	a.append(l5)
	a.append(l6)
	a.append(l7)
	a.append(l8)
	a.append(l9)
	a.append(l10)
func _process(delta):
	if Input.is_action_just_pressed("dash"):
		$RichTextLabel.text=a[count]
		if count==1:
			$Sprite.visible=true
			$AudioStreamPlayer.play()
		else:
			$Sprite.visible=false
		count+=1
		$Tween.interpolate_property($RichTextLabel,"percent_visible",0,1,3,Tween.TRANS_LINEAR,Tween.EASE_OUT)
		$Tween.start()
		pass
	if Input.is_action_just_pressed("ui_focus_next"):
		$AudioStreamPlayer.play()
		var inst=slime.instance()
		inst.position=Vector2(141,73)
		add_child(inst)
	if Input.is_action_just_pressed("ui_accept"):
		var inst=crystal.instance()
		$AudioStreamPlayer.play()
		inst.position=Vector2(20,68)
		add_child(inst)
		pass

extends Node2D

var fighting=load("res://audio/Daniel Parejo - Reventure -OST- - 06 Hot Volcano.wav")
var fighting2=load("res://audio/Daniel Parejo - Reventure -OST- - 12 Pirate\'s Cliff.wav")
var town=load("res://audio/Daniel Parejo - Reventure -OST- - 02 The Collector.wav")
var boss=load("res://audio/Daniel Parejo - Reventure -OST- - 13 Ridiculous Desert.wav")
func play_fighting():
	$AudioStreamPlayer.stream=fighting
	$AudioStreamPlayer.play()

func play_fighting2():
	$AudioStreamPlayer.stream=fighting2
	$AudioStreamPlayer.play()
func play_town():
	$AudioStreamPlayer.stream=town
	$AudioStreamPlayer.play()

func play_boss():
	$AudioStreamPlayer.stream=boss
	$AudioStreamPlayer.play()

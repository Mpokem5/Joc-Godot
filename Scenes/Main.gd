extends Node2D

var score : int = 0
var health : int = 0

func _process(delta):
	if score >= 20:
		score = 0
		get_tree().change_scene("res://Scenes/YouWin.tscn")

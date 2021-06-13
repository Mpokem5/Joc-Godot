extends Node2D

func _process(delta):
	if Input.is_action_pressed("space"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")



extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var SPEED = 1000
var direction : Vector2
var shooter : Node


# Called when the node enters the scene tree for the first time.
func ini(dir:Vector2, pos:Vector2) -> void:
	position = pos
	direction = dir
	rotation = direction.angle()

func _physics_process(delta):
	position += direction * SPEED * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("wall"):
		print("paret")
		queue_free()

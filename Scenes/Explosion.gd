extends Sprite

onready var anim = $AnimationPlayer

func _ready():
	anim.play("Explosion")
	$Explode.play()
	

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

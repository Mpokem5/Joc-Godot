extends Area2D

var SPEED = 1000
var direction : Vector2
var shooter : Node
var damage
var origin
var projectile_speed

onready var explosion = preload("res://Scenes/Explosion.tscn")


func _ready():
	if origin == "Player":
		damage = 10
		projectile_speed = 300
		set_collision_mask_bit(1,false)
	elif origin == "Enemy":
		damage = 1
		projectile_speed = 300
		set_collision_mask_bit(2,false)

# Called when the node enters the scene tree for the first time.
func ini(dir:Vector2, pos:Vector2) -> void:
	position = pos
	direction = dir
	rotation = direction.angle()
	$Shoot.play()

func _physics_process(delta):
	position += direction * SPEED * delta


func _on_Bullet_body_entered(body):
#	get_node("CollisionShape2D").set_deferred("disabled", true)
	if body.is_in_group("Enemies") and origin == "Player":
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_node("/root/Joc/Explosion").add_child(explosion_instance)
		body.OnHit(damage)
		self.hide()
	elif body.is_in_group("Player") and origin =="Enemy":
		var explosion_instance = explosion.instance()
		explosion_instance.position = get_global_position()
		get_node("/root/Joc/Explosion").add_child(explosion_instance)
		body.OnHit(damage)
		self.hide()
	if body.is_in_group("wall"):
		self.hide()

		
	


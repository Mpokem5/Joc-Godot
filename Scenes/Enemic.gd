extends KinematicBody2D

onready var player = get_parent().get_node("Player")


var speed = 120
var max_hp = 400
var current_hp
var dead = false
var state = "Rest"
var can_fire = true

var fire_direction 
var player_position

var player_in_range
var player_in_sight

func _ready():
	current_hp = max_hp
	
func _process (delta):
		match state:
			"Rest":
				print ("ZZZZZ")
			"Attack":
				if can_fire == true:
					Attack()
				else:
					pass
			"Follow":
				pass
			"Search":
				pass


func _physics_process(delta):
	SightCheck()

func Attack():
	can_fire = false
	speed = 0
	get_node("TurnAxis").rotation = get_angle_to(player_position)
	var Bullet_Enemic = preload("res://Scenes/Bullet.tscn")
#	var bullet_instance = Bullet_Enemic.instance()
#	bullet_instance.rotation = get_angle_to(player_position)
#	bullet_instance.position = get_node("TurnAxis/CastPoint").get_global_position()
#	bullet_instance.origin = "Enemy"
#	get_parent().add_child(bullet_instance)
	var bullet_instance = Bullet_Enemic.instance()
	var direction = (get_global_mouse_position() - position).normalized()
	bullet_instance.rotation = get_angle_to(player_position)
	bullet_instance.position = get_node("TurnAxis/CastPoint").get_global_position()
	bullet_instance.ini(direction,bullet_instance.position )
	get_node("/root/Joc/YSort/Bullet").add_child(bullet_instance)
	yield(get_tree().create_timer(0.6), "timeout")
	can_fire = true
	speed = 120

func OnHit(damage):
	current_hp -= damage
	if current_hp <=0:
		 OnDeath()
		
func OnDeath():
	dead = true
#	get_node("AnimationPlayer").play("Death")
	get_node("CollisionPolygon2D").set_deferred("disabled", true)
	print("I am Death")


#func _physics_process(delta):
#	move = Vector2.ZERO
#
#	if player != null:
#		move = position.direction_to(player.position) * speed
#	else: 
#		move = Vector2.ZERO
#
#	move = move.normalized()
#	move = move_and_collide(move)
#
#
#func _on_Area2D_body_entered(body):
#	if body != self:
#		player = body
#
#
#func _on_Area2D_body_exited(body):
#	player = null
#
#func fire():
#	var bullet=BULLET_SCENE.instance()
#	bullet.position = get_global_position()
#	bullet.player = player
#	get_parent().add_child(bullet)
#	$Timer.set_wait_time(1)
#
#func _on_Timer_timeout():
#	if player != null:
#		fire()


func _on_Sight_body_entered(body):
	if body == player:
		player_in_range = true

func _on_Sight_body_exited(body):
	if body == player:
		player_in_range = false
		
func SightCheck():
	if player_in_range == true:
		var space_state = get_world_2d().direct_space_state
		var sight_check = space_state.intersect_ray(position, player.position, [self], collision_mask)
		if sight_check:
			if sight_check.collider.name == "Player":
				player_in_sight = true
				player_position = player.get_global_position()
				state = "Attack"
			else :
				player_in_sight = false
				state = "Rest"

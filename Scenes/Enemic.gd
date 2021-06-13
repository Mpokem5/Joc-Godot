extends KinematicBody2D

onready var player = get_parent().get_node("Player")
onready var map_navegation = get_parent().get_node("Navigation2D")


var speed = 120
var max_hp = 400
var current_hp
var dead = false
var state = "Rest"
var can_fire = true

var player_position

var player_in_range
var player_in_sight
var player_seen
var destination


func _ready():
	current_hp = max_hp

func _process (delta):
		match state:
			"Rest":
				pass
			"Attack":
				if can_fire == true:
					Attack()
				else:
					pass
			"Search":
				Search(delta)


func _physics_process(delta):
	SightCheck()

func Attack():
	can_fire = false
	speed = 1
	get_node("TurnAxis").rotation = get_angle_to(player_position)
	var Bullet_Enemic = preload("res://Scenes/Bullet.tscn")
	var bullet_instance = Bullet_Enemic.instance()
	var direction = (get_global_mouse_position() - position).normalized()
	bullet_instance.rotation = get_angle_to(player_position)
	bullet_instance.position = get_node("TurnAxis/CastPoint").get_global_position()
	bullet_instance.ini(direction,bullet_instance.position )
	bullet_instance.origin = "Enemy"
	get_node("/root/Joc/YSort/Bullet").add_child(bullet_instance)
	yield(get_tree().create_timer(0.6), "timeout")
	can_fire = true
	speed = 120
	
func Search(delta):
	var path_to_destination = map_navegation.get_simple_path(get_global_position(), destination)
	var starting_point = get_global_position()
	var move_distance = speed * delta
	
	for point in range (path_to_destination.size()):
		var distance_to_next_point = starting_point.distance_to(path_to_destination[0])
		if move_distance <= distance_to_next_point:
			var move_rotation = get_angle_to(starting_point.linear_interpolate(path_to_destination[0], move_distance/distance_to_next_point))
			var motion = Vector2(speed,0).rotated(move_rotation)
			move_and_slide(motion)
			break
		move_distance-=distance_to_next_point
		starting_point = path_to_destination[0]
		path_to_destination.remove(0)
		
	if path_to_destination.size() == 0:
		player_seen = false
		state = "Rest"

func OnHit(damage):
	current_hp -= damage
	if current_hp <=0:
		 OnDeath()

func OnDeath():
	dead = true
#	get_node("AnimationPlayer").play("Death")
#	get_node("CollisionPolygon2D").set_deferred("disabled", true)
	queue_free()

func _on_Sight_body_entered(body):
	if body == player:
		player_in_range = true

func _on_Sight_body_exited(body):
	if body == player:
		player_in_range = false
		if player_seen == true:
			state = "Search"

func SightCheck():
	if player_in_range == true:
		var space_state = get_world_2d().direct_space_state
		var sight_check = space_state.intersect_ray(position, player.position, [self], collision_mask)
		if sight_check:
			if sight_check.collider.name == "Player":
				player_in_sight = true
				player_seen = true
				player_position = player.get_global_position()
				destination = map_navegation.get_closest_point(player_position)
				state = "Attack"
			else :
				player_in_sight = false
				if(player_seen == true):
					state = "Search"
				else:
					state = "Rest"


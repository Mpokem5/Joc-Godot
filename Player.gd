extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bullet = preload("res://Scenes/Bullet.tscn")
var dir : String
var moving : bool
var can_dash : bool = true
var CENTER : Vector2 = get_viewport_rect().size/2
var SPEED : int = 5000
const ROTATION := {"U" : Vector2(0,-1), "D" : Vector2(0,1), "L" : Vector2(-1,0), "R" : Vector2(1,0),
					"UR" : Vector2(0.5,-0.5), "UL" : Vector2(-0.5,-0.5), "DR" : Vector2(0.5,0.5), "DL" : Vector2(-0.5,0.5)}

# Called when the node enters the scene tree for the first time.
func _ready():
	CENTER = get_viewport_rect().size/2
	for i in ROTATION:
		ROTATION[i] = ROTATION[i].normalized()
	pass # Replace with function body.
	
func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		shoot()


func _physics_process(delta):
	moving = true
	if Input.is_action_pressed("ui_up"):
		if Input.is_action_pressed("ui_right"):
			dir = "UR"
		elif Input.is_action_pressed("ui_left"):
			dir = "UL"
		else:
			dir = "U"
	elif Input.is_action_pressed("ui_down"):
		if Input.is_action_pressed("ui_right"):
			dir = "DR"
		elif Input.is_action_pressed("ui_left"):
			dir = "DL"
		else:
			dir = "D"
	elif Input.is_action_pressed("ui_right"):
		dir = "R"
	elif Input.is_action_pressed("ui_left"):
		dir = "L"
	else:
		moving = false
	if moving:
		if Input.is_action_just_released("dash") && can_dash:
			dash()
		move(delta)

func shoot():
	var direction = (get_global_mouse_position() - position).normalized()
	var bullet_ins = bullet.instance()
	bullet_ins.ini(direction,position)
	get_tree().get_root().add_child(bullet_ins)
	print(dir)
	
func move(delta) -> void:
	var movement = delta * SPEED * ROTATION[dir]
	move_and_slide(movement)
	
func dash() -> void:
	SPEED = 50000
	can_dash = false
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	SPEED = 5000
	can_dash = true

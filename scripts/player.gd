extends CharacterBody2D
class_name Player

var speed = 300.0
@export var gravity = 15
var max_fall_velocity = 1000
var viewport_size

func _ready():
	viewport_size = get_viewport_rect().size


func _process(delta):
	pass

func _physics_process(delta):
	if velocity.y < max_fall_velocity:
		velocity.y += gravity
	
	var direction = Input.get_axis("move_left","move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
	
	var margin = 30
	if global_position.x > viewport_size.x + margin:
		global_position.x = -margin
		
	if global_position.x < -margin:
		global_position.x = viewport_size.x + margin

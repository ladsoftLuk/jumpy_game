extends Node2D

@onready var platform_parent = $PlatformParent

var camera_scene = preload("res://scenes/game_camera.tscn")
var platform_scene = preload("res://scenes/platform.tscn")

var camera: GameCamera = null

#Level gen variables
var generated_platform_count = 0
var y_distance_between_platform = 100
var level_size = 10
var viewport_size
var start_platform_y

func _ready():
	camera = camera_scene.instantiate()
	camera.setup_camera($Player)
	add_child(camera)
	viewport_size = get_viewport_rect().size
	start_platform_y = viewport_size.y - (y_distance_between_platform * 2)
	generate_level(start_platform_y, 1)
	
	
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if $Player:
		var py = $Player.position.y
		var end_of_level = start_platform_y - (y_distance_between_platform * generated_platform_count)
		var threshold = end_of_level + (y_distance_between_platform * 6)
		if $Player.position.y <= threshold:
			print("Generate nwe")
			generate_level(end_of_level, 0)
	
func create_platform(location: Vector2):
	if location:
		var platform: Platform = platform_scene.instantiate()
		platform.global_position = location
		platform_parent.add_child(platform)
		return platform

func generate_level(start_y: float, generate_ground: bool):
	
	var platform_witdh = 136
	var ground_platform_count = (viewport_size.x / platform_witdh) + 1
	var groud_y_offset = 62
	if generate_ground:
		for i in range(ground_platform_count):
			var vector = Vector2( i * platform_witdh, viewport_size.y - groud_y_offset)
			create_platform(vector)
		
	var location: Vector2
	for i in level_size:
		location.x = randi_range(0, viewport_size.x - platform_witdh)
		location.y = start_y - (y_distance_between_platform * i)
		create_platform(location)
		generated_platform_count += 1
		

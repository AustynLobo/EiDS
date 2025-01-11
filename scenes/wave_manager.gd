extends Node2D

@export var target: Node2D
@export var max_zombies = 30
@export var max_zombies_per_spawn = 5
@export var disable_distance = 400

@onready var spawn_timer = $SpawnTimer
@onready var zombies = $Zombies

var zombie_scene = preload("res://scenes/zombie.tscn")

var spawn_points = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child.name.begins_with("SpawnPoint"):
			spawn_points.append(child)
	spawn_zombies()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_zombies():
	var existing_zombies = zombies.get_child_count()
	
	var i = 0
	while i < max_zombies_per_spawn and existing_zombies + i < max_zombies:
		var spawn_point: Node2D = spawn_points.pick_random()
		if spawn_point.global_position.distance_to(target.global_position) <= disable_distance:
			continue
	
		var offset = Vector2(randf_range(-20, 20), randf_range(-20, 20))
		
		var zombie = zombie_scene.instantiate()
		zombie.global_position = spawn_point.global_position + offset
		zombie.target = target
		
		zombies.add_child(zombie)
		i += 1

func _on_spawn_timer_timeout() -> void:
	spawn_zombies()
		
		

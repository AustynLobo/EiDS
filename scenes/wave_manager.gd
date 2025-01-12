extends Node2D

@export var target: Node2D
@export var wave_zombie_counts = [15, 25, 35]
@export var max_zombies_per_spawn = 10
@export var disable_distance = 400

@onready var spawn_timer = $SpawnTimerW
@onready var zombies = $Zombies

var current_wave = 0

@export var hud: CanvasLayer

var spawned_zombies = []
var killed_zombies = []

var zombie_scene = preload("res://scenes/zombie.tscn")

var spawn_points = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(wave_zombie_counts)):
		spawned_zombies.push_back(0)
		killed_zombies.push_back(0)
		
	for child in get_children():
		if child.name.begins_with("SpawnPoint"):
			spawn_points.append(child)
	
	start_wave()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_zombies():	
	if (current_wave >= len(wave_zombie_counts)):
		return
	
	var i = 0
	while i < max_zombies_per_spawn and spawned_zombies[current_wave] < wave_zombie_counts[current_wave]:
		var spawn_point: Node2D = spawn_points.pick_random()
		if is_instance_valid(target) and spawn_point.global_position.distance_to(target.global_position) <= disable_distance:
			continue
	
		var offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
		
		var zombie = zombie_scene.instantiate()
		zombie.global_position = spawn_point.global_position + offset
		zombie.target = target

		zombie.scale_factor = randf_range(0.8, 1.7)
		zombie.zombie_dead.connect(_on_zombie_dead)
		
		zombies.add_child(zombie)
		i += 1
		spawned_zombies[current_wave] += 1

func start_wave():
	if (current_wave >= len(wave_zombie_counts)):
		return

	hud.update_current_wave(current_wave + 1)
	hud.update_max_waves(len(wave_zombie_counts))
	
	hud.update_zombies_killed(killed_zombies[current_wave])
	hud.update_max_zombies(wave_zombie_counts[current_wave])
	
	spawn_zombies()

func _on_spawn_timer_timeout() -> void:
	spawn_zombies()

func _on_zombie_dead() -> void:
	killed_zombies[current_wave] += 1
	hud.update_zombies_killed(killed_zombies[current_wave])
	if (killed_zombies[current_wave] >= wave_zombie_counts[current_wave]):
		hud.trigger_wave_complete_label(current_wave + 1)
		current_wave += 1
		start_wave()

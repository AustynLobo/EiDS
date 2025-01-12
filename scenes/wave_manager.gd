extends Node2D

@export var target: Node2D
@export var wave_zombie_counts: Array[int] = [15, 25, 35]
@export var max_zombies_per_spawn = 10
@export var max_zombies_at_once = 25
@export var disable_distance = 400

@export var boss_scale = 3.0
@export var boss_damage = 80.0
@export var boss_speed = 20.0
@export var boss_health = 500.0
@export var boss_attack_cooldown = 2.0
@export var boss_attack_speed = 1.5

@onready var spawn_timer = $SpawnTimer
@onready var zombies = $Zombies

var current_wave = 0

@export var hud: CanvasLayer
@export var game_over: CanvasLayer
var spawned_zombies = []
var killed_zombies = []

var zombie_scene = preload("res://scenes/zombie.tscn")

var spawn_points = []

var boss_zombie = null
var boss_zombie_health_system = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(wave_zombie_counts) + 1):
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
	var i = 0
	
	var can_spawn_zombies = func can_spawn_zombies(i):
		var less_than_spawn_limit = i < max_zombies_per_spawn and zombies.get_child_count() < max_zombies_at_once
		if is_boss_wave():
			return less_than_spawn_limit
		return less_than_spawn_limit and spawned_zombies[current_wave] < wave_zombie_counts[current_wave]
		
	while can_spawn_zombies.call(i):
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

func spawn_boss():
	var spawn_point: Node2D = null
	while spawn_point == null:
		var point = spawn_points.pick_random()
		if is_instance_valid(target) and point.global_position.distance_to(target.global_position) <= disable_distance:
			spawn_point = point
	
	boss_zombie = zombie_scene.instantiate()
	boss_zombie.global_position = spawn_point.global_position
	boss_zombie.target = target
	
	boss_zombie.scale_factor = boss_scale
	boss_zombie.custom_attack_speed = boss_attack_speed
	boss_zombie.custom_attack_cooldown = boss_attack_cooldown
	boss_zombie.custom_max_health = boss_health
	boss_zombie.custom_damage = boss_damage
	boss_zombie.custom_speed = boss_speed
	
	boss_zombie.zombie_dead.connect(_on_zombie_dead)
	boss_zombie.zombie_dead.connect(_on_boss_zombie_dead)
	
	boss_zombie_health_system = boss_zombie.get_node("HealthSystem")
	boss_zombie_health_system.took_damage.connect(_on_boss_damage_taken)
	
	hud.update_boss_health(boss_health)
	hud.update_boss_max_health(boss_health)
	
	zombies.add_child(boss_zombie)
	spawned_zombies[current_wave] += 1
	
func start_wave():
	if is_boss_wave():
		hud.is_boss_wave = true
		hud.update_current_wave(current_wave + 1)
		hud.update_zombies_killed(killed_zombies[current_wave])
		spawn_boss()
		return

	hud.update_current_wave(current_wave + 1)
	hud.update_max_waves(len(wave_zombie_counts))
	
	hud.update_zombies_killed(killed_zombies[current_wave])
	hud.update_max_zombies(wave_zombie_counts[current_wave])
	
	spawn_zombies()

func is_boss_wave():
	return current_wave >= len(wave_zombie_counts)


func _on_spawn_timer_timeout() -> void:
	spawn_zombies()

func _on_zombie_dead() -> void:
	killed_zombies[current_wave] += 1
	hud.update_zombies_killed(killed_zombies[current_wave])
	
	if is_boss_wave():
		return

		
	if (killed_zombies[current_wave] >= wave_zombie_counts[current_wave]):
		hud.trigger_wave_complete_label(current_wave + 1)
		current_wave += 1
		start_wave()

func _on_boss_damage_taken() -> void:
	if is_instance_valid(boss_zombie_health_system):
		hud.update_boss_health(boss_zombie_health_system.current_health)
	else:
		hud.update_boss_health(0)

func _on_boss_zombie_dead():
	game_over.display("You Win!")

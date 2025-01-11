extends Node2D

@export var damage = 50
@export var player_distance: float = 30
@onready var player = get_parent()

@onready var attack_animation = $AttackAnimation
@onready var area = $Area2D

var gun

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gun = player.get_node("Gun")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var mouse_vector = get_global_mouse_position() - player.position
	
	if (mouse_vector.length() >= player_distance):
		position = mouse_vector.normalized() * player_distance
			
	if Input.is_action_just_pressed("melee"):
		attack_animation.play()
		var ammo_gained = 0
		for body in area.get_overlapping_bodies():
			if body == get_parent():
				continue
			var health_system = body.get_node_or_null("HealthSystem")
			
			if health_system:
				var alive_before = health_system.is_alive()
				health_system.take_damage(damage)
				var alive_after = health_system.is_alive()
				if alive_before and not alive_after:
					ammo_gained += 2
		gun.add_ammo(min(ammo_gained, 4))
	
	if attack_animation.is_playing():
		attack_animation.flip_v = mouse_vector.y < 0
		attack_animation.visible = true
	else:
		attack_animation.visible = false

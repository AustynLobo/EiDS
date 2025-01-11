extends Node2D

@export var damage = 50
@export var player_distance: float = 30
@onready var player = get_parent()

@onready var attack_animation = $AttackAnimation
@onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var mouse_vector = get_global_mouse_position() - player.position
	
	if (mouse_vector.length() >= player_distance):
		position = mouse_vector.normalized() * player_distance
			
	if Input.is_action_just_pressed("melee"):
		attack_animation.play()
		for body in area.get_overlapping_bodies():
			if body == get_parent():
				continue
			var health_system = body.get_node_or_null("HealthSystem")
			if health_system:
				health_system.take_damage(damage)
	
	if attack_animation.is_playing():
		attack_animation.flip_v = mouse_vector.y < 0
		attack_animation.visible = true
	else:
		attack_animation.visible = false

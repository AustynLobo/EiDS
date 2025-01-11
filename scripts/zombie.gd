extends CharacterBody2D

signal zombie_dead

@export var scale_factor = 1.0
@export var damage = 20.0
@export var speed = 70
@export var target: Node2D
@export var stopping_distance: float = 40.0

@onready var health_system = $HealthSystem

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _navigation_agent: NavigationAgent2D = $Navigation/NavigationAgent2D

@onready var _attack_area: Node2D = $AttackArea
@onready var _attack_polygon: Polygon2D = $AttackArea/AttackPolygon
@onready var _attack_progress_animation: AnimationPlayer = $AttackArea/AttackProgressPolygon/AnimationPlayer
@onready var _attack_timer: Timer = $AttackArea/Timer
@onready var _cooldown_timer: Timer = $AttackArea/CooldownTimer
@onready var _swipe_animation: AnimatedSprite2D = $SwipeAnimation

var target_health_system = null

var is_attacking = false
var target_in_range = false

var swipe_x

func _ready() -> void:
	target_health_system = target.get_node_or_null("HealthSystem")
	swipe_x = _swipe_animation.position.x

	scale *= scale_factor
	damage = damage + ((scale_factor - 1) * damage) / 1.5
	speed = speed - ((scale_factor - 1) * speed) / 0.8
	health_system.set_max_health(health_system.max_health + ((scale_factor - 1) * health_system.max_health) / 0.8 - 50)

func _physics_process(delta: float) -> void:
	if is_instance_valid(target) and not is_attacking:
		move_to_target()
		align_attack_area()
	
	animate()

func align_attack_area():
	_attack_area.rotation = (target.global_position - global_position).angle()
	if target_in_range and _cooldown_timer.is_stopped():
		start_attack()

func start_attack():
	if is_attacking:
		return
		
	is_attacking = true
	_attack_timer.start()
	_attack_progress_animation.play("ZombieAttackProgress", -1, 1.0 / _attack_timer.wait_time)

func move_to_target():
	var direction = Vector2.ZERO
	
	var distance = global_position.distance_to(target.global_position)
	
	if distance > stopping_distance:
		direction = _navigation_agent.get_next_path_position() - global_position
		direction = direction.normalized()
	
	velocity = direction * speed
	
	move_and_slide()

func animate():
	if velocity.length() == 0:
		_animated_sprite.play("idle")
	else:
		_animated_sprite.play("move")
		_animated_sprite.flip_h = velocity.x < 0
	
	if (_swipe_animation.is_playing()):
		_swipe_animation.visible = true
	else:
		_swipe_animation.visible = false
		
	_attack_polygon.visible = is_attacking

func _on_nav_timer_timeout() -> void:
	if is_instance_valid(target):
		_navigation_agent.target_position = target.global_position

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body == target:
		target_in_range = true

func _on_attack_timer_timeout() -> void:
	if target_in_range and target_health_system:
		target_health_system.take_damage(damage)
	is_attacking = false
	_attack_progress_animation.stop()
	_cooldown_timer.start()
	
	_swipe_animation.play()
	if _attack_area.rotation >= -PI / 2 and _attack_area.rotation <= PI / 2:
		_swipe_animation.position.x = swipe_x
	else:
		_swipe_animation.position.x = -swipe_x

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body == target:
		target_in_range = false


func _on_health_system_health_depleted() -> void:
	target.get_node("Gun").add_ammo(randi_range(0, 6))
	queue_free()

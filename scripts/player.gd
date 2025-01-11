extends CharacterBody2D

@export var speed = 300.0

@onready var _animated_sprite = $AnimatedSprite2D
var bullet_TSCN = preload("res://scenes/bullet.tscn")
@export var game : Node2D

@onready var gun = $Gun
@onready var muzzle = $Gun/Muzzle

@onready var melee_attack_animation = $MeleeAttack/AttackAnimation

var camera: Camera2D

func _ready() -> void:
	camera = get_node_or_null("Camera2D")

func _physics_process(delta: float) -> void:
	if not melee_attack_animation.is_playing() and Input.is_action_just_pressed("shoot"):
		var bullet_ins: Area2D = bullet_TSCN.instantiate()
		game.add_child(bullet_ins)
		bullet_ins.global_position = muzzle.global_position
		bullet_ins.direction = Vector2.RIGHT.rotated(gun.rotation)
	
	if melee_attack_animation.is_playing():
		gun.visible = false
	else:
		gun.visible = true
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		if direction.x:
			_animated_sprite.flip_h = direction.x < 0
		velocity = direction * speed
		_animated_sprite.play("move")
	else:
		velocity = Vector2.ZERO
		_animated_sprite.play("idle")

	move_and_slide()


func _on_health_system_health_depleted() -> void:
	if camera:
		self.remove_child(camera)
		get_parent().add_child(camera)
		camera.global_position = global_position
	queue_free()

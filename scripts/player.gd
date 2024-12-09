extends CharacterBody2D

const SPEED = 100.0

@onready var _animated_sprite = $AnimatedSprite2D
var bullet_TSCN = preload("res://scenes/bullet.tscn")
@export var game : Node2D
@export var gun : Node2D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		var bullet_ins: Area2D = bullet_TSCN.instantiate()
		game.add_child(bullet_ins)
		bullet_ins.global_position = gun.muzzle.global_position
		bullet_ins.direction = Vector2.RIGHT.rotated(gun.rotation)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if direction:
		if direction.x:
			_animated_sprite.flip_h = direction.x < 0
		velocity = direction * SPEED
		_animated_sprite.play("move")
	else:
		velocity = Vector2.ZERO
		_animated_sprite.play("idle")

	move_and_slide()
	

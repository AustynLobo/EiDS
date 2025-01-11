extends CharacterBody2D

@export var speed = 300.0

@onready var _animated_sprite = $AnimatedSprite2D
var bullet_TSCN = preload("res://scenes/bullet.tscn")
@export var game : Node2D
@onready var gun = $Gun
@onready var muzzle = $Gun/Muzzle

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		var bullet_ins: Area2D = bullet_TSCN.instantiate()
		game.add_child(bullet_ins)
		bullet_ins.global_position = muzzle.global_position
		bullet_ins.direction = Vector2.RIGHT.rotated(gun.rotation)
		$Pistol_Shoot.play()
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

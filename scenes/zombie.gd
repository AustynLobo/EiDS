extends CharacterBody2D

@export var speed = 50.0
@export var target: Node2D

@onready var _animated_sprite = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	var target_vector = target.position - position
	
	velocity = target_vector.normalized() * speed
	if velocity.length() == 0:
		_animated_sprite.play("idle")
	else:
		_animated_sprite.play("move")
		_animated_sprite.flip_h = velocity.x < 0
	move_and_slide()

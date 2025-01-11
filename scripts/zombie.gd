extends CharacterBody2D

@export var speed = 50.0
@export var target: Node2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _navigation_agent: NavigationAgent2D = $Navigation/NavigationAgent2D

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	direction = _navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = direction * speed
	
	if velocity.length() == 0:
		_animated_sprite.play("idle")
	else:
		_animated_sprite.play("move")
		_animated_sprite.flip_h = velocity.x < 0
	
	move_and_slide()


func _on_timer_timeout() -> void:
	_navigation_agent.target_position = target.global_position

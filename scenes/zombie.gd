extends CharacterBody2D

@export var speed = 50.0
@export var target: Node2D
@export var nav_agent: NavigationAgent2D
var target_node = null
var home_pos = Vector2.ZERO

@onready var _animated_sprite = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
		
	var axis = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = axis * speed

	
	if velocity.length() == 0:
		_animated_sprite.play("idle")
	else:
		_animated_sprite.play("move")
		_animated_sprite.flip_h = velocity.x < 0
	
	move_and_slide()
	

func recalc_path(): # calculate path to home using target node 
	if target_node:
		nav_agent.target_position = target_node.global_position 
	else:
		nav_agent.target_position = home_pos
	
func _ready():
	home_pos = self.global_position
	nav_agent.path_desired_distance = 4
	
	nav_agent.target_desired_distance = 4


func _on_recalculate_timer_timeout() -> void:
	recalc_path()

func _on_aggro_range_body_entered(body: Node2D) -> void:
	target_node = body


func _on_deaggro_range_body_exited(body: Node2D) -> void:
	if body == target_node:
		target_node = null 

extends RigidBody2D

@export var muzzle_speed = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func projectile_movement(delta):
	position += muzzle_speed * transform.x * delta
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

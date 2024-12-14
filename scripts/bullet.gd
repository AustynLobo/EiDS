extends Area2D

@export var muzzle_speed = 100
var direction: Vector2 = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = direction.normalized() * muzzle_speed
	translate(velocity * delta)
	rotation = direction.angle()
	

func _on_body_entered(body: Node2D) -> void:
	queue_free()

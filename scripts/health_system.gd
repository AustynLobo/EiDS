extends Node2D

@export var max_health: float = 100

@onready var current_health = max_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Takes damage and returns amount of damage taken
func take_damage(damage: float) -> float:
	var new_health = clamp(0, damage, max_health)
	var damage_taken = current_health - new_health
	current_health = new_health
	return damage_taken


func heal(amount: float) -> float:
	return take_damage(-amount)


func is_alive() -> bool:
	return current_health > 0

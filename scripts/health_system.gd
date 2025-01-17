extends Node2D

@export var max_health: float = 100

@onready var current_health = max_health
@onready var invulnerability_timer = $InvulnerabilityTimer

signal health_depleted
signal took_damage
signal health_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Takes damage and returns amount of damage taken
func take_damage(damage: float) -> float:
	if not invulnerability_timer.is_stopped():
		return 0
		
	var new_health = clamp(current_health - damage, 0, max_health)
	var damage_taken = current_health - new_health
	current_health = new_health
	
	if current_health == 0:
		health_depleted.emit()
	
	invulnerability_timer.start()
	
	health_changed.emit()
	took_damage.emit()
	
	return damage_taken

func set_max_health(amount: float):
	max_health = amount
	current_health = amount

func heal(amount: float) -> float:
	var new_health = clamp(current_health + amount, 0, max_health)
	var amount_healed = new_health - current_health
	current_health = new_health
	health_changed.emit()
	return amount_healed


func is_alive() -> bool:
	return current_health > 0

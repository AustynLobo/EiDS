extends Node2D

@export var player_distance: float = 20
@onready var player = get_parent()

@onready var _sprite = $Sprite2D

@export var millis_between_shots = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_vector = get_global_mouse_position() - player.position
	
	if (mouse_vector.length() >= player_distance):
		position = mouse_vector.normalized() * player_distance
		
		rotation = mouse_vector.angle()
		_sprite.flip_v = mouse_vector.x < 0
		_sprite.position.y = -4 if mouse_vector.x < 0 else 4
	

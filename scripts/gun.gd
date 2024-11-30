extends Node2D

@export var player_distance: float = 20
@export var player: Node2D

@onready var _sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("You have fired the gun!")

	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_vector = get_global_mouse_position() - player.position
	if (mouse_vector.length() >= player_distance):
		position = mouse_vector.normalized() * player_distance
		
		rotation = mouse_vector.angle()
		_sprite.flip_v = mouse_vector.x < 0
	

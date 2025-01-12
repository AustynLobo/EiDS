extends Node2D

@export var player_distance: float = 20
@onready var player = get_parent()

@onready var _sprite = $Sprite2D

@export var max_ammo = 30

@onready var current_ammo = max_ammo / 2

var hud

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud = player.hud
	hud.update_ammo(current_ammo)
	hud.update_max_ammo(max_ammo)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var mouse_vector = get_global_mouse_position() - player.position
	
	if (mouse_vector.length() >= player_distance):
		position = mouse_vector.normalized() * player_distance
		
		rotation = mouse_vector.angle()
		_sprite.flip_v = mouse_vector.x < 0
		_sprite.position.y = -4 if mouse_vector.x < 0 else 4
	
func add_ammo(amount):
	current_ammo = clamp(current_ammo + amount, 0, max_ammo)
	hud.update_ammo(current_ammo)

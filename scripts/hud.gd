extends CanvasLayer

@onready var health_label: Label = $HealthLabel
@onready var ammo_label: Label = $AmmoLabel

var health = 0
var max_health = 0

var ammo = 0
var max_ammo = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_health_label()
	update_ammo_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_health_label():
	if is_instance_valid(health_label):
		var health_percentage = (health / max_health) * 100
		health_label.text = "Health: %.2f%%" % health_percentage

func update_ammo_label():
	if is_instance_valid(ammo_label):
		ammo_label.text = "Ammo: " + str(ammo) + "/" + str(max_ammo)


func update_health(amount):
	health = amount
	update_health_label()

func update_max_health(amount):
	max_health = amount
	update_health_label()

func update_ammo(amount):
	ammo = amount
	update_ammo_label()

func update_max_ammo(amount):
	max_ammo = amount
	update_ammo_label()

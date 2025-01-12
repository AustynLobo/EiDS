extends CanvasLayer

@onready var health_label: Label = $HealthLabel
@onready var ammo_label: Label = $AmmoLabel
@onready var wave_label: Label = $WaveLabel
@onready var wave_zombies_label: Label = $WaveZombiesLabel
@onready var wave_end_label: Label = $WaveEndLabel
@onready var stopwatch: Label = $Stopwatch
@onready var tip_label: Label = $TipLabel

@export var tips: Array[String]

var is_boss_wave = false

var health = 0
var max_health = 0

var ammo = 0
var max_ammo = 0

var current_wave = 0
var max_waves = 0

var zombies_killed = 0
var max_zombies = 0

var boss_health = 0
var boss_max_health = 0

@onready var start_time = Time.get_ticks_msec()

var current_tip = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_health_label()
	update_ammo_label()
	update_wave_label()
	update_wave_zombies_label()
	
	wave_end_label.visible = false
	
	tip_label.get_node("WaitTimer").start()
	tip_label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_elapsed = Time.get_ticks_msec() - start_time
	
	var seconds = time_elapsed / 1000
	var minutes = seconds / 60
	var remaining_seconds = seconds % 60
	
	stopwatch.text = "%02d:%02d" % [minutes, remaining_seconds]

func update_health_label():
	if is_instance_valid(health_label):
		var health_percentage = (health / max_health) * 100
		health_label.text = "Health: %.2f%%" % health_percentage

func update_ammo_label():
	if is_instance_valid(ammo_label):
		ammo_label.text = "Ammo: " + str(ammo) + "/" + str(max_ammo)

func update_wave_label():
	if is_instance_valid(wave_label):
		if is_boss_wave:
			wave_label.text = "Austyn, Destroyer of Worlds"
		else:
			wave_label.text = "Wave: " + str(current_wave) + "/" + str(max_waves)

func update_wave_zombies_label():
	if is_instance_valid(wave_zombies_label):
		if is_boss_wave:
			wave_zombies_label.text = "Health: %.2f/%.2f" % [boss_health, boss_max_health]
		else:
			wave_zombies_label.text = "Zombies killed: " + str(zombies_killed) + "/" + str(max_zombies)

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

func update_current_wave(amount):
	current_wave = amount
	update_wave_label()

func update_max_waves(amount):
	max_waves = amount
	update_wave_label()

func update_zombies_killed(amount):
	zombies_killed = amount
	update_wave_zombies_label()

func update_max_zombies(amount):
	max_zombies = amount
	update_wave_zombies_label()

func update_boss_health(amount):
	boss_health = amount
	update_wave_zombies_label()

func update_boss_max_health(amount):
	boss_max_health = amount
	update_wave_zombies_label()

func trigger_wave_complete_label(completed_wave):
	wave_end_label.text = "Wave " + str(completed_wave) + " Complete!"
	wave_end_label.visible = true
	wave_end_label.get_node("Timer").start()

func _on_wave_end_timer_timeout() -> void:
	wave_end_label.visible = false


func _on_tip_wait_timer_timeout() -> void:
	if (current_tip < len(tips)):
		tip_label.visible = true
		tip_label.text = tips[current_tip]
		tip_label.get_node("DisplayTimer").start()


func _on_display_timer_timeout() -> void:
	tip_label.visible = false
	current_tip += 1
	tip_label.get_node("WaitTimer").start()

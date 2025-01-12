extends CanvasLayer

@onready var game_over_label = $GameOverLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display(text):
	game_over_label.text = text
	get_tree().paused = true
	visible = true
	

func _on_button_pressed() -> void:
	print("!")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/title_screen.tscn")

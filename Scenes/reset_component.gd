extends Node2D
class_name ResetComponent

var parent : Node2D
var starting_position : Vector2

# Options 
@export var remove_off_screen := true
@export var remove_on_what_y := 2000.0
@export_enum("Remove on Reset", "Reposition on Reset") var reset_option := 0

func _ready() -> void:
	# Get parent
	parent = get_parent()
	if parent == null:
		print_debug("Reset component initialized incorrectly.")

	# Get starting position
	starting_position = parent.global_position
	
	# Signals
	SignalBus.game_start.connect(_on_start_game)

func _process(delta: float) -> void:
	if remove_off_screen and parent.global_position.y >= remove_on_what_y:
		parent.queue_free()

func _on_start_game() -> void:
	match reset_option:
		0:
			parent.queue_free()
		1:
			parent.global_position = starting_position

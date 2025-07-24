extends Node2D
class_name MovementComponent

@export var scroll_magnitude := 1.0

## For linear movement.
@export var movement_velocity := Vector2.ZERO

# Initialize player manager to copy scroll speed from
@onready var player_manager := GameManager.player_manager
var parent : Node2D

func _ready() -> void:
	parent = get_parent()
	if parent == null:
		print_debug("Movement component initialized incorrectly.")

func _physics_process(delta: float) -> void:
	scroll_movement(delta)
	movement(delta)

func scroll_movement(delta: float) -> void:
	var scroll_speed = player_manager.get_scroll_speed() * scroll_magnitude
	parent.global_position.y -= scroll_speed * delta

# Supports linear movement
func movement(delta: float) -> void:
	parent.global_position += movement_velocity * delta

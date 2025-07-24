extends Area2D
class_name Enemy

## Velocity removed from the player firework when collided.
@export var hit_velocity := 50.0

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).apply_propulsion_velocity(-hit_velocity)

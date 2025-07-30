extends Area2D
class_name Enemy

## Velocity removed from the player firework when collided.
@export var hit_velocity := 50.0

## State whether the enemy is hit by the player or not
var is_hit := false

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not is_hit:
		(body as Player).apply_propulsion_velocity(-hit_velocity)
		death()

# On hit behavior
func death() -> void:
	modulate = Color.DIM_GRAY
	is_hit = true

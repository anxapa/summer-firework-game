# TODO: Remove critical sections prior to game launch

class_name Cash 
extends Area2D
@export var cash_value := 1
var starting_position
# false indicates fixed spawn
var spawned = false

static var scene: PackedScene = load("res://Scenes/cash.tscn")

func _ready() -> void:
	# CRITICAL: remove if condition after deprecating fixed spawns
	if (spawned):
		global_position = starting_position

func _on_body_entered(body: Node2D) -> void:
	if body is Player and visible:
		GameManager.cash_collected += cash_value
		queue_free()

static func spawn(starting_position: Vector2) -> Cash:
	var spawn : Cash = scene.instantiate()
	spawn.spawned = true
	spawn.starting_position = starting_position - Vector2(0, starting_position.y)
	return spawn

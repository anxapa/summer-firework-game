# TODO: Remove critical sections prior to game launch

class_name Patterns
extends Node2D
@export var cash_value := 1
var starting_position
# false indicates fixed spawn
var spawned = false
@onready var animation_player := $AnimationPlayer
var pattern_ : String

static var scene := load("res://Cash Patterns/patterns.tscn")


func _ready() -> void:
	animation_player.play(pattern_)
	global_position = starting_position

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.cash_collected += cash_value
		queue_free()

static func spawn(starting_position: Vector2, pattern: String) -> Node2D:
	var spawn : Node2D = scene.instantiate()
	spawn.pattern_ = pattern
	spawn.starting_position = starting_position - Vector2(0, starting_position.y)
	return spawn

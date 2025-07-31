# TODO: Remove critical sections prior to game launch
# 		Add Weight support to animations

# NOTE: AnimationPlayer patterns should be no bigger than 128x128 wide (centered on the node anchors) to accomodate spawn_manager and cash sprite size.

class_name Patterns
extends Node2D
var spawn_position
@onready var animation_player := $AnimationPlayer
var pattern_ : String

# Static Variables
static var scene := load("res://Cash Patterns/patterns.tscn")
static var patterns := ["diamond", "smile", "line", "plus"]

func _ready() -> void:
	pattern_ = patterns.pick_random()
	animation_player.current_animation = pattern_
	# global_position = spawn_position

static func spawn(spawn_position: Vector2, pattern: String) -> Node2D:
	var spawn : Node2D = scene.instantiate()
	spawn.pattern_ = pattern
	spawn.spawn_position = spawn_position
	return spawn
	
static func get_rand_pattern() -> String:
	return patterns.pick_random()

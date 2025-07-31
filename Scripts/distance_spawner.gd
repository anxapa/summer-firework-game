extends Node2D
class_name DistanceSpawner

@onready var player := GameManager.player_manager.player
var spawn_manager : SpawnManager
## Scene to spawn
@export var scene : Array[PackedScene]
## Parent to attach spawned scenes
@export var parent : Node2D
@export var margin := 200.0

# Distance stuff
## Minimum distance (in km) from previous spawn to spawn the scene
@export var min_distance := 2.0
## Maximum distance (in km) from previous spawn to spawn the scene
@export var max_distance := 5.0

var distance_since_spawn := 0.0

func _ready() -> void:
	distance_since_spawn = randf_range(min_distance, max_distance)
	spawn_manager = get_parent()
	
	# Signal
	SignalBus.game_start.connect(_on_game_start)

func spawn() -> void:
	var total_distance = -player.total_distance
	
	if total_distance > distance_since_spawn:
		var child = scene.pick_random().instantiate()
		parent.add_child(child)
		child.global_position = spawn_manager.get_random_position(margin)
		
		distance_since_spawn += randf_range(min_distance, max_distance)

func _on_game_start() -> void:
	distance_since_spawn = randf_range(min_distance, max_distance)

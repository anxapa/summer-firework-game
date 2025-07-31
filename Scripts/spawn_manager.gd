class_name SpawnManager
extends Node2D
@export var cash_parent : Node2D
@export var timer : Timer
@export var cloud_cutoff_distance := 20.0
@onready var player_manager := GameManager.player_manager

var disabled := false

# Strange OFF_SCREEN constant to prevent animationPlayer flickering 
const OFF_SCREEN_Y = 1080/2 + 312

# Determines timing between pattern spawns (this should change according to player speed in some way)
var p_interval_min := 2
var p_interval_max := 3

# Determines many seconds worth of travel is needed to reach the next pattern
var p_x_min := 0.0
var p_x_max := 0.0

var p_y_min := 2
var p_y_max := 3

# Spawners
@onready var rocket_spawner := $"Rocket Spawner"
@onready var cloud_spawner := $"Cloud Spawner"
@onready var cloud2_spawner := $"Cloud2 Spawner"
@onready var enemy_spawner := $"Enemy Spawner"
@onready var cash_spawner := $"Cash Spawner"

func _ready() -> void:
	GameManager.spawn_manager = self
	var x = randf_range(p_interval_min, p_interval_max)
	timer.wait_time = x
	#timer.timeout.connect(_spawn_cash)

# Spawning Guidelines?

# Patterns should be spawned at least one seconds worth of travel above the player
# Patterns should never be spawned more than two seconds worth of y travel above the player--unless two seconds worth of travel is on-screen
# Patterns will be spawned every x seconds determined by the interval
#
# ... I think all of these need to be scrapped
func _process(delta: float) -> void:
	if disabled:
		return
	
	rocket_spawner.spawn()
	enemy_spawner.spawn()
	cash_spawner.spawn()
	
	# Spawns cloud until the cutoff
	if -player_manager.player.total_distance < cloud_cutoff_distance:
		cloud_spawner.spawn()
		cloud2_spawner.spawn()

func _spawn_cash() -> void:
	if disabled:
		return
	
	var p_y_distance := randf_range(p_y_min * player_manager.get_scroll_speed(), p_y_max * player_manager.get_scroll_speed())
	var p_x_distance := 0
	
	var test = Patterns.spawn(player_manager.player.global_position + Vector2(p_x_distance, min(p_y_distance, -OFF_SCREEN_Y)), Patterns.get_rand_pattern())
	cash_parent.add_child(test)

# Get a random position to spawn something above off screen
func get_random_position(margin := 200.0) -> Vector2:
	var viewport_size : Vector2i = get_viewport().size
	var new_position := Vector2(randf_range(margin, viewport_size.x - margin), -margin)
	
	return new_position

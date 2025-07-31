extends Node2D

@export var background_mvmnt : MovementComponent
@onready var player = GameManager.player_manager.player
var rolling := false

func _physics_process(delta: float) -> void:
	SignalBus.game_start.connect(_on_game_start)
	if GameManager.player_manager.player.total_distance < -50 and not rolling:
		rolling = true
		roll_credits()
	elif rolling and not player.is_thrusting:
		player.propulsion_velocity = 300
		player.current_thrust = player.max_thrust
		pass

# wow this is so cool
func roll_credits() -> void:
	background_mvmnt.scroll_magnitude = 0
	GameManager.spawn_manager.process_mode = 4
	GameManager.player_manager.player.GRAVITY = 0
	$Control.visible = true
	$Control.global_position.y = GameManager.player_manager.player.global_position.y - (1080/2 + 312)
	$MovementComponent.scroll_magnitude = 0.2
	await get_tree().create_timer(25).timeout
	player.death()

func _on_game_start() -> void:
	$Control.global_position = Vector2(0, 0)
	$Control.visible = false
	rolling = false
	background_mvmnt.scroll_magnitude = 0.05
	

extends ProgressBar

var player : Player

func _ready() -> void:
	# Get the player from the player manager
	player = GameManager.player_manager.player

func _process(delta: float) -> void:
	# Updates the thrust values from the player
	max_value = player.max_thrust
	value = player.current_thrust

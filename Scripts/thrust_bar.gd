extends ProgressBar

var player : Player

func _ready() -> void:
	# Get the player from the player manager
	player = GameManager.player_manager.player
	
	# Signals
	SignalBus.game_start.connect(_on_game_start)

func _process(delta: float) -> void:
	# Do not show bar if there is no thrust
	if player.max_thrust == 0:
		visible = false
	else:
		visible = true
	
	# Updates the thrust values from the player
	max_value = player.max_thrust
	value = move_toward(value, player.current_thrust, delta * 2)

func _on_game_start() -> void:
	# Change the values instantly so it does not need to catch up every time
	max_value = player.max_thrust
	value = player.current_thrust

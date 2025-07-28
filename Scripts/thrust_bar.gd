extends ProgressBar

var player : Player

func _ready() -> void:
	# Get the player from the player manager
	player = GameManager.player_manager.player

func _process(delta: float) -> void:
	# Do not show bar if there is no thrust
	if player.max_thrust == 0:
		visible = false
	else:
		visible = true
	
	# Updates the thrust values from the player
	max_value = player.max_thrust
	value = player.current_thrust

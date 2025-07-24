extends Label

var player : Player

func _ready() -> void:
	# Get the player from the player manager
	player = GameManager.player_manager.player

func _process(delta: float) -> void:

	
	# Show player speed
	text = "%d mph" % -player.scroll_speed

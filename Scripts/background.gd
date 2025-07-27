extends Sprite2D

var starting_position : Vector2

func _ready() -> void:
	starting_position = global_position
	SignalBus.connect("game_start", _on_game_start)

func _on_game_start() -> void:
	# Reset to starting position on game start
	global_position = starting_position

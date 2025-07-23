extends Node2D
class_name PlayerManager

@export var player : Player

func _ready() -> void:
	GameManager.player_manager = self

func get_scroll_speed() -> float:
	return player.scroll_speed

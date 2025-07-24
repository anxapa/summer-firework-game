extends Node2D
@export var cash_parent : Node2D
@export var cloud_parent : Node2D

func _ready() -> void:
	var test = Patterns.spawn(GameManager.player_manager.player.global_position, "diamond")
	cash_parent.add_child(test)
	print_debug("help")

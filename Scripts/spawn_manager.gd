extends Node2D
@export var cash_parent : Node2D
@export var cloud_parent : Node2D

func _ready() -> void:
	var test = Cash.spawn(GameManager.player_manager.player.global_position)
	cash_parent.add_child(test)
	print_debug("help")

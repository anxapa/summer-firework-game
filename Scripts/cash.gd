extends Area2D

@export var cash_value := 1

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.cash_collected += cash_value
		queue_free()

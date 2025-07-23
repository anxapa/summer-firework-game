extends Label

func _process(delta: float) -> void:
	text = "%03d" % GameManager.cash_collected

extends Label

func _process(delta: float) -> void:
	text = "x %d" % GameManager.get_cash_multiplier() 

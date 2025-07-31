extends Label

func _process(delta: float) -> void:
	# Changes the text if the cash is in the thousands or millions
	var cash : float = GameManager.cash_collected
	
	if cash > 1000000:
		text = "%.1fm" % (cash / 1000000)
	elif cash > 1000:
		text = "%.1fk" % (cash / 1000)
	else:	
		text = "%03d" % GameManager.cash_collected

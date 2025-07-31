extends Sprite2D

@export var alternate_texture : Texture2D

func _ready() -> void:
	# Chance of being alternate texture
	if randf() > 0.5:
		texture = alternate_texture
	
	# Chance of being flipped 
	if randf() > 0.5:
		flip_h = true

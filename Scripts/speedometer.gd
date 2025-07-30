extends Label

var player : Player

@export_category("Colors")
@export var normal_color : Color
@export var near_death_color : Color
@export var death_color : Color

func _ready() -> void:
	# Get the player from the player manager
	player = GameManager.player_manager.player

func _process(delta: float) -> void:
	# Show player speed
	if player.scroll_speed > -1000:
		text = "%d m/s" % -player.scroll_speed
	else:
		text = "%.1f km/s" % -(player.scroll_speed / 1000)
	
	# Change color when near player death
	if player.propulsion_velocity > player.death_velocity + 100:
		label_settings.font_color = normal_color
	elif player.propulsion_velocity > player.death_velocity + 50:
		label_settings.font_color = near_death_color
	else:
		label_settings.font_color = death_color
		

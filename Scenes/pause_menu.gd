extends Panel

@export var animation_player : AnimationPlayer

# Buttons (mainly for disabling / enabling them)
@onready var home_button := $"Pause Panel/Home Button"
@onready var settings_button := $"Pause Panel/Settings Button"
@onready var upgrades_button := $"Pause Panel/Upgrades Button"
@onready var back_button := $"Pause Panel/Back Button"

func _ready() -> void:
	# CRITICAL: Temporarily disabling the buttons not functionable yet
	disable_button(home_button)
	disable_button(settings_button)
	disable_button(upgrades_button)

func _process(_delta: float) -> void:
	# Checks for whenever the player is using an escape key
	if Input.is_action_just_pressed("ui_cancel"):
		# Different behaviors depending on the game state
		# Uh should be pretty self-explanatory
		match GameManager.current_game_state:
			GameManager.GameStates.PAUSED:
				unpause()
			GameManager.GameStates.GAME:
				pause()

func pause() -> void:
	GameManager.current_game_state = GameManager.GameStates.PAUSED
	animation_player.play("on_pause")
	get_tree().paused = true

func unpause() -> void:
	GameManager.current_game_state = GameManager.GameStates.GAME
	animation_player.play("unpause")
	get_tree().paused = false

func enable_button(button: Button) -> void:
	button.disabled = false
	button.modulate = Color.WHITE

func disable_button(button: BaseButton) -> void:
	button.disabled = true
	button.modulate = Color.GRAY

# Functionality when back button is pressed (duh)
func _on_back_button_pressed() -> void:
	unpause()

# Functionality when background is pressed (duh)
func _on_background_button_pressed() -> void:
	unpause()

# Functionality when pause button is pressed (duh)
func _on_pause_button_pressed() -> void:
	pause()

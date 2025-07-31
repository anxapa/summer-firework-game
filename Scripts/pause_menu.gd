extends Panel

@onready var animation_player := $AnimationPlayer

# Buttons (mainly for disabling / enabling them)
@onready var home_button := $"Pause Panel/Home Button"
@onready var settings_button := $"Pause Panel/Settings Button"
@onready var upgrades_button := $"Pause Panel/Upgrades Button"
@onready var back_button := $"Pause Panel/Back Button"

func _ready() -> void:
	# CRITICAL: Temporarily disabling the buttons not functionable yet
	disable_button(home_button)
	disable_button(settings_button)

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
	animation_player.play("on_pause")
	$Pause.play_one_shot()
	get_tree().paused = true
	
	# Only change game state if it is unpaused
	if GameManager.current_game_state == GameManager.GameStates.GAME:
		GameManager.current_game_state = GameManager.GameStates.PAUSED
	
	# Disable some buttons depending on the game state
	if GameManager.current_game_state == GameManager.GameStates.SHOP:
		disable_button(upgrades_button)
		GameManager.audio_manager.shop_music.paused = true
	else:
		enable_button(upgrades_button)

func unpause() -> void:
	animation_player.play("unpause")
	$Unpause.play_one_shot()
	# Different functionality depending on Game state
	match GameManager.current_game_state:
		GameManager.GameStates.PAUSED:
			GameManager.current_game_state = GameManager.GameStates.GAME
			get_tree().paused = false
		GameManager.GameStates.SHOP:
			GameManager.audio_manager.shop_music.paused = false
			get_tree().paused = true

func go_to_upgrades() -> void:
	GameManager.current_game_state = GameManager.GameStates.SHOP
	animation_player.play("unpause")
	print_debug("help")
	get_tree().paused = true

func enable_button(button: BaseButton) -> void:
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

func _on_upgrades_button_pressed() -> void:
	go_to_upgrades()

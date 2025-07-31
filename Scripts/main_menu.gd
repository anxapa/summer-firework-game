extends Control

# Children
@onready var animation_player := $AnimationPlayer

func _ready() -> void:
	animation_player.play("play_menu")
	get_tree().paused = true

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	animation_player.play("exit_menu")
	GameManager.start_game()

func _on_home_button_pressed() -> void:
	GameManager.current_game_state = GameManager.GameStates.MAIN_MENU
	animation_player.play("play_menu")
	get_tree().paused = true

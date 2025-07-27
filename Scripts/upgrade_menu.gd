extends Control

@onready var animation_player := $AnimationPlayer

func open_upgrade_panel() -> void:
	animation_player.play("enter_menu")

func close_upgrade_panel() -> void:
	animation_player.play("exit_menu")

# Functionality of the play button in the upgrade menu
func _on_play_button_pressed() -> void:
	close_upgrade_panel()
	GameManager.start_game()

# Functionality of the upgrades button on the pause menu
func _on_upgrades_button_pressed() -> void:
	open_upgrade_panel()

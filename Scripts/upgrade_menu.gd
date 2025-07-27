extends Panel

func _ready() -> void:
	close_upgrade_panel()

func open_upgrade_panel() -> void:
	visible = true

func close_upgrade_panel() -> void:
	visible = false

# Functionality of the play button in the upgrade menu
func _on_play_button_pressed() -> void:
	close_upgrade_panel()
	GameManager.start_game()

# Functionality of the upgrades button on the pause menu
func _on_upgrades_button_pressed() -> void:
	open_upgrade_panel()

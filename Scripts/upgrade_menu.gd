extends Control

# Children
@onready var animation_player := $AnimationPlayer
@onready var upgrades_parent := $"Upgrade Panel/Upgrades"
@onready var buy_button := $"Upgrade Panel/Buy Button"
var upgrades : Array[UpgradeButton]

# Upgrade button selection
var selected_upgrade : UpgradeButton

func _ready() -> void:
	# Put all the upgrades in the array
	for button in upgrades_parent.get_children():
		if button is UpgradeButton:
			upgrades.append(button as UpgradeButton)

			# Rebind the button press/hover to pass on itself as an argument
			button.pressed.connect(_on_upgrade_pressed.bind(button))

# Select a certain upgrade in the menu
func select_upgrade(num : int) -> void:
	deselect_upgrade()
	var upgrade = upgrades[num]
	selected_upgrade = upgrade
	upgrade.modulate = Color.WHITE

# Deselect the previous selected upgrade
func deselect_upgrade() -> void:
	# Makes sure that there is a selected upgrade
	if not selected_upgrade:
		return
	
	selected_upgrade.modulate = Color.GRAY

# Disable upgrade
func disable_upgrade(num : int) -> void:
	var upgrade = upgrades[num]
	upgrade.disabled = true
	upgrade.modulate = Color.WEB_GRAY

# Update the shop to reflect current levels / etc.
func update_shop_contents() -> void:
	# Update each label in the upgrades
	for n in upgrades.size():
		upgrades[n].update(n)
		
		# Make sure every button is initially enabled 
		upgrades[n].disabled = false
		upgrades[n].modulate = Color.GRAY
		
		# If the upgrade has not been bought before and is too expensive,
		# then disable it
		if upgrades[n].current_level == 0 and upgrades[n].cost > GameManager.cash_collected:
			disable_upgrade(n)

func open_upgrade_panel() -> void:
	update_shop_contents()
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

func _on_upgrade_pressed(button: UpgradeButton) -> void:
	select_upgrade(button.upgrade_type)

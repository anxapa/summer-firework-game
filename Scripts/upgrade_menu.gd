extends Control

# Children
@onready var animation_player := $AnimationPlayer
@onready var upgrades_parent := $"Upgrade Panel/Upgrades"
@onready var buy_button := $"Upgrade Panel/Buy Button"
@onready var desc_label := $"Upgrade Panel/Text Panel/Description Label"
var upgrades : Array[UpgradeButton]

# Sounds
@onready var buy1_sound := $"Upgrade Panel/Sounds/Shop Buy1 Sound"
@onready var buy2_sound := $"Upgrade Panel/Sounds/Shop Buy2 Sound"
@onready var open_sound := $"Upgrade Panel/Sounds/Shop Open Sound"

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
func select_upgrade(button: UpgradeButton) -> void:
	deselect_upgrade(selected_upgrade)
	selected_upgrade = button
	button.select()
	update_description()
	
	# Disable buy button if cost is not buyable
	var upgrade = button.upgrade_type
	buy_button.disabled = not PlayerUpgrades.is_upgrade_buyable(upgrade)

# Deselect the previous selected upgrade
func deselect_upgrade(button: UpgradeButton) -> void:
	# Makes sure that there is a selected upgrade
	if not selected_upgrade:
		return
	
	button.deselect()

# Update the shop to reflect current levels / etc.
func update_shop_contents() -> void:
	# Update each label in the upgrades
	for n in upgrades.size():
		var button = upgrades[n]
		button.update(n)
		
		# Make sure every button is initially enabled 
		button.disable(false)
		
		# If the upgrade has not been bought before and is too expensive,
		# then disable it
		if button.current_level == 0 and button.cost > GameManager.cash_collected:
			button.disable(true)

# Update the upgrade description depending on the selected upgrade
func update_description() -> void:
	# If there is no selected button, put placeholder text
	if not selected_upgrade:
		desc_label.text = "Click on an upgrade to see its effects!"
		return
	
	desc_label.text = PlayerUpgrades.upgrade_descriptions[selected_upgrade.upgrade_type]

# Buy upgrade
func buy_current_upgrade() -> void:
	var upgrade = selected_upgrade.upgrade_type
	PlayerUpgrades.increment_upgrade(upgrade)
	
	# Update shop & buy button
	update_shop_contents()
	select_upgrade(selected_upgrade)
	
	# Sound
	# Buy1 sound - for upgrades that are not max level
	if PlayerUpgrades.current_upgrades[upgrade] < PlayerUpgrades.get_max_upgrade_count(upgrade):
		buy1_sound.play(true)
	# Buy2 sound - for upgrades that are max level
	else:
		buy2_sound.play(true)

func open_upgrade_panel() -> void:
	GameManager.current_game_state = GameManager.GameStates.SHOP
	
	# Deselect on enter
	deselect_upgrade(selected_upgrade)
	selected_upgrade = null
	buy_button.disabled = true
	update_description()
	
	update_shop_contents()
	animation_player.play("enter_menu")
	open_sound.play(true)

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
	select_upgrade(button)

func _on_buy_button_pressed() -> void:
	buy_current_upgrade()

func _on_home_button_pressed() -> void:
	visible = false

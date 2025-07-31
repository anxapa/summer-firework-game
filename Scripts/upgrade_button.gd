extends Button
class_name UpgradeButton

var upgrade_type : PlayerUpgrades.UPGRADES
var currently_selected := false

# Stats
var cost : int
var current_level : int
var max_level : int

# Children
@onready var name_label := $"Name Label"
@onready var progress_bar := $ProgressBar
@onready var progress_label := $"Progress Label"
@onready var cost_label := $"Cost Label"
@onready var sprite := $Sprite2D

# Modulate colors
var normal_color := Color.LIGHT_GRAY
var pressed_color := Color.DIM_GRAY
var hover_color := Color.GRAY
var selected_color := Color.WHITE

func update(upgrade: PlayerUpgrades.UPGRADES):
	var cost_array: Array = PlayerUpgrades.upgrade_costs[upgrade]
	
	# Assigning stats
	current_level = PlayerUpgrades.current_upgrades[upgrade]
	max_level = PlayerUpgrades.get_max_upgrade_count(upgrade)
	# If upgrade is maxed out, then it cannot be bought anymore
	if current_level == max_level:
		cost = -1
	else:
		cost = cost_array[current_level]
	
	update_name(PlayerUpgrades.upgrade_names[upgrade])
	update_progress_bar(current_level, max_level)
	update_cost(cost)
	update_logo(PlayerUpgrades.upgrade_logos[upgrade])
	
	upgrade_type = upgrade

func update_name(name : String) -> void:
	name = name.replace(" ", "\n")
	name_label.text = name

func update_progress_bar(current_level : int, max_level : int) -> void:
	progress_bar.value = current_level
	progress_bar.max_value = max_level
	progress_label.text = "%d / %d" % [current_level, max_level]

func update_cost(cost: int) -> void:
	# If the cost is unbuyable
	if cost == -1:
		cost_label.text = "MAXED"
		return
	
	# Changes the cost name if it is over 1000
	if cost < 1000:
		cost_label.text = "$ %d" % cost
	else:
		cost_label.text = "$ %.1fk" % (cost / 1000)

func update_logo(texture : Texture2D) -> void:
	sprite.texture = texture

func select() -> void:
	modulate = selected_color
	currently_selected = true

func deselect() -> void:
	modulate = normal_color
	currently_selected = false

func disable(option: bool) -> void:
	disabled = option
	if option:
		modulate = pressed_color
	else:
		modulate = normal_color

# On hover color
func _on_mouse_entered() -> void:
	if not disabled and not currently_selected:
		modulate = hover_color

# On hover exit color
func _on_mouse_exited() -> void:
	if not disabled and not currently_selected:
		modulate = normal_color

# On press color
func _on_pressed() -> void:
	if not disabled:
		modulate = pressed_color

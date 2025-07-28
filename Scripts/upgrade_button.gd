extends Button
class_name UpgradeButton

var upgrade_type : PlayerUpgrades.UPGRADES

# Stats
var cost : int
var current_level : int
var max_level : int

# Children
@onready var name_label := $"Name Label"
@onready var progress_bar := $ProgressBar
@onready var progress_label := $"Progress Label"
@onready var cost_label := $"Cost Label"

func update(upgrade: PlayerUpgrades.UPGRADES):
	var cost_array: Array = PlayerUpgrades.upgrade_costs[upgrade]
	
	# Assigning stats
	current_level = PlayerUpgrades.current_upgrades[upgrade]
	max_level = cost_array.size()
	cost = cost_array[current_level]
	
	update_name(PlayerUpgrades.upgrade_names[upgrade])
	update_cost(cost)
	update_progress_bar(current_level, max_level)
	
	upgrade_type = upgrade

func update_name(name : String) -> void:
	name = name.replace(" ", "\n")
	name_label.text = name

func update_progress_bar(current_level : int, max_level : int) -> void:
	progress_bar.value = current_level
	progress_bar.max_value = max_level
	progress_label.text = "%d / %d" % [current_level, max_level]

func update_cost(cost: int) -> void:
	if cost < 1000:
		cost_label.text = "$ %d" % cost
	else:
		cost_label.text = "$ %.1fk" % (cost / 1000)

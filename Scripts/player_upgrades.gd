extends Node

class_name PlayerUpgrades

# Upgrades
enum UPGRADES {
	THRUST,
	THRUST_SPEED,
	MAGNET,
	TURN_SPEED,
	LAUNCH_VELOCITY,
	INVINCIBLE_THRUST,
	GUN,
	BOOST_ACCELERATION,
	CASH_DIAMOND,
}

static var current_upgrades : Array[int]

# Max upgrades will be dependent on this
static var upgrade_costs := [
	[1, 10, 100], #THRUST,
	[1, 10, 100], #THRUST_SPEED,
	[100000, 1000000], #MAGNET,
	[100000, 1000000], #TURN_SPEED,
	[100000, 1000000], #LAUNCH_VELOCITY,
	[100000, 1000000], #INVINCIBLE_THRUST,
	[100000, 1000000], #GUN,
	[100000, 1000000], #BOOST_ACCELERATION,
	[100000, 1000000], #CASH_DIAMOND,
	]

static var upgrade_names := [
	"Thrust",
	"Thrust Speed",
	"Magnet",
	"Turn Speed",
	"Launch Velocity",
	"Invincible Thrust",
	"Gun",
	"Boost Acceleration",
	"Cash Diamond",
]

static func initialize() -> void:
	# Puts 0 in every upgrade slot to start
	for n in UPGRADES.size():
		current_upgrades.append(0)

## Increments an upgrade based on its cost.
## If the cost is buyable
static func increment_upgrade(upgrade: UPGRADES) -> bool:
	if is_upgrade_buyable(upgrade):
		var cost_array: Array = upgrade_costs[upgrade]
		var cost = cost_array[current_upgrades[upgrade]]
		current_upgrades[upgrade] += 1
		GameManager.cash_collected -= cost
		return true
	else:
		return false

## Checks if the upgrade is buyable with the current cash
static func is_upgrade_buyable(upgrade: UPGRADES) -> bool:
	# If the upgrade is maxed out, return false
	var cost_array: Array = upgrade_costs[upgrade]
	if current_upgrades[upgrade] >= upgrade_costs[upgrade].size():
		return false
	
	var cost = cost_array[current_upgrades[upgrade]]
	return cost <= GameManager.cash_collected

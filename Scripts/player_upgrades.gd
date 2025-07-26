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
static var max_upgrades : Array[int]

static func initialize() -> void:
	# Puts 0 in every upgrade slot to start
	# CRITICAL: Temporarily putting in 5 for max of each upgrade for testing
	for n in UPGRADES.size():
		current_upgrades.append(0)
		max_upgrades.append(5)

## Increments an upgrade based on its cost.
## If the cost is buyable
static func increment_upgrade(upgrade: UPGRADES, cost: int) -> bool:
	if cost <= GameManager.cash_collected:
		current_upgrades[upgrade] += 1
		GameManager.cash_collected -= cost
		return true
	else:
		return false

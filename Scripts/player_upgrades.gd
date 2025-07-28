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
	[10, 100], #THRUST,
	[100000, 1000000], #THRUST_SPEED,
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
static func increment_upgrade(upgrade: UPGRADES, cost: int) -> bool:
	if cost <= GameManager.cash_collected:
		current_upgrades[upgrade] += 1
		GameManager.cash_collected -= cost
		return true
	else:
		return false

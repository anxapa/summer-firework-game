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
	BOOST_ACCELERATION,
	CASH_DIAMOND,
	GUN,
}

static var current_upgrades : Array[int]

# Max upgrades will be dependent on this
static var upgrade_costs := [
	[1, 100, 500, 1000], #THRUST,
	[20, 200, 1000], #THRUST_SPEED,
	[50, 750, 5000], #MAGNET,
	[100, 1500, 5000], #TURN_SPEED,
	[100, 2000, 5000, 10000], #LAUNCH_VELOCITY,
	[500, 5000], #INVINCIBLE_THRUST,
	[500, 5000], #BOOST_ACCELERATION,
	[100, 2000, 5000, 10000], #CASH_DIAMOND,
	[10000000, 100000000], #GUN,
	]

static var upgrade_names := [
	"Thrust",
	"Thrust Speed",
	"Magnet",
	"Turn Speed",
	"Launch Velocity",
	"Invincible Thrust",
	"Boost Acceleration",
	"Cash Diamond",
	"Gun",
]

static var upgrade_descriptions := [
	"Press [Spacebar] to activate thrust, giving you an extra boost and makes enemies hit less!\n\n" + 
			"Each upgrade gives 2.5s of thrust.", # THRUST,
	"Upgrading this will make your thrust even more faster!", # THRUST_SPEED,
	"This increases your collection radius, allowing you to collect from far away!", # MAGNET,
	"Each upgrade of this will give you more horizontal speed, " + 
			"allowing for more agile movements!", # TURN_SPEED,
	"Adds more initial velocity to your ascent! \n\n" +
			"Each upgrade adds 100m\\s to your initial velocity", # LAUNCH_VELOCITY,
	"With this upgrade, obstacles will no longer be a problem for you.\n\n" +
			"Each upgrade reduces damage you take from obstacles while thrusting!", # INVINCIBLE_THRUST,
	"Fellow fireworks will help you more!\n\n" +
			"Each upgrade adds 25% more boost from fireworks.", # BOOST_ACCELERATION,
	"Has a chance of turning your cash to diamonds! \n\n" +
			"Each upgrade gives 25% chance for the effect to occur.", # CASH_DIAMOND,
	"...", # GUN,
]

# Textures 
static var upgrade_logos := [
	load("res://Sprites/Upgrade Logos/thrust_logo.png"), #THRUST,
	load("res://Sprites/Upgrade Logos/thrust_speed_logo.png"), # THRUST_SPEED,
	load("res://Sprites/Upgrade Logos/magnet_logo.png"), # MAGNET,
	load("res://Sprites/Upgrade Logos/turn_speed_logo.png"), # TURN_SPEED,
	load("res://Sprites/Upgrade Logos/launch_velocity_logo.png"), # LAUNCH_VELOCITY,
	load("res://Sprites/Upgrade Logos/invincible_thrust_logo.png"), # INVINCIBLE_THRUST,
	load("res://Sprites/Upgrade Logos/boost_speed_logo.png"), # BOOST_ACCELERATION,
	load("res://Sprites/Upgrade Logos/cash_diamond_logo.png"), # CASH_DIAMOND,
	load("res://Sprites/Upgrade Logos/gun_logo.png"), # GUN,
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
	if current_upgrades[upgrade] >= get_max_upgrade_count(upgrade):
		return false
	
	var cost = cost_array[current_upgrades[upgrade]]
	return cost <= GameManager.cash_collected

static func get_max_upgrade_count(upgrade: UPGRADES) -> int:
	return upgrade_costs[upgrade].size()

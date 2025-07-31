extends CharacterBody2D
class_name Player

# Child Nodes
@onready var smoke_particles := $"Smoke Particles"
@onready var death_particles := $"Death Particles"
@onready var sprite := $Sprite
@onready var magnet_shape := $"MagnetArea/CollisionShape2D"

# Physics values
@export var initial_velocity := 300.0
var turn_speed := 400
var starting_position : Vector2
var propulsion_velocity : float
var outside_velocity := Vector2.ZERO
var scroll_speed : float
# Player dies reaching this velocity
var death_velocity := 100.0
var GRAVITY := 10

# Thrust
@export_group("Thrust")
@export var thrust_velocity := 500
@export var max_thrust := 2.5
var current_thrust : float

# Upgrades
var boost_multiplier := 1.0
var hurt_multiplier := 1.0

# Textures 
@export_group("Textures")
@export var normal_texture : Texture2D
@export var boost_texture : Texture2D

# Sounds
@onready var thrust_sound := $"Sounds/ThrustSound"
@onready var diamond_sound := $"Sounds/DiamondSound"
@onready var coin_sound := $"Sounds/CoinSound"

# States
var is_thrusting := false
var is_dead := false

# Stats per run
var total_distance := 0.0
var cash_collected := 0

func _ready() -> void:
	# Records starting position set in the editor
	starting_position = global_position
	
	# Initializes the player
	_on_game_start()
	
	# Connecting signals
	SignalBus.connect("game_start", _on_game_start)

func _physics_process(delta: float) -> void:
	# No changes if dead
	if is_dead:
		return
	
	thrust_handling(delta)
	apply_gravity(delta)
	movement(delta)
	clamp_position()
	death_check()
	update_particles()
	
func movement(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction := Vector2(Input.get_axis("ui_left", "ui_right"), 0).normalized()
	
	# Moves in input direction. If no input direction, moves to the zero vector.
	if direction:
		velocity = direction * propulsion_velocity * turn_speed
	else:
		velocity = velocity.lerp(Vector2.ZERO, turn_speed * 10 * delta)
	
	# Add in outside velocity and propulsion velocity
	velocity += outside_velocity
	outside_velocity = Vector2.ZERO
	velocity.y -= propulsion_velocity
	
	# Add y velocity to the total distance
	total_distance += velocity.y * delta / 1000
	
	# Put velocity y into scroll speed
	scroll_speed = velocity.y
	velocity.y = 0

	#if GameManager.current_game_state == GameManager.GameStates.GAME:
		#thrust_sound.set_parameter("Panning", (global_position.x - 960)/19.2)
		#thrust_sound.play(false)
	
	move_and_slide()

func apply_gravity(delta: float) -> void:
	propulsion_velocity = move_toward(propulsion_velocity, 1, GRAVITY * delta)

func apply_propulsion_velocity(velocity: float) -> void:
	# Positive velocity is boost from fireworks
	if velocity > 0:
		velocity *= boost_multiplier
	# Negative velocity is deceleration from enemies
	if velocity < 0 and is_thrusting:
		velocity *= hurt_multiplier
	
	propulsion_velocity += velocity

func apply_velocity(velocity: Vector2) -> void:
	outside_velocity += velocity

func add_thrust(num: float) -> void:
	current_thrust = move_toward(current_thrust, max_thrust, num * boost_multiplier)

func thrust_handling(delta: float) -> void:
	# Thrust handling
	if Input.is_key_pressed(KEY_SPACE) and current_thrust > 0:
		is_thrusting = true
		thrust(delta)
		sprite.texture = boost_texture
	else:
		is_thrusting = false
		sprite.texture = normal_texture

func thrust(delta: float) -> void:
	current_thrust = move_toward(current_thrust, 0, delta)
	apply_velocity(Vector2(0, -thrust_velocity))

func death_check() -> void:
	if propulsion_velocity < death_velocity and not is_thrusting:
		death()

## Player dies
func death() -> void:
	# Temporary behavior
	scroll_speed = 0
	smoke_particles.emitting = false
	death_particles.emitting = true
	sprite.visible = false
	is_dead = true
	set_collision_layer_value(1, false) # Disable collisions
	
	await get_tree().create_timer(3.0).timeout
	SignalBus.emit_signal("player_death")

## Sets the parameters of the particle system depending on propulsion velocity
func update_particles() -> void:
	# Sets the speed of the particle system
	smoke_particles.initial_velocity_min = propulsion_velocity * 2
	smoke_particles.initial_velocity_max = propulsion_velocity * 2
	
	# Sets the scale of the particle system
	smoke_particles.scale_amount_max = (100 / -(propulsion_velocity + 50)) + 4
	smoke_particles.scale_amount_min = smoke_particles.scale_amount_max / 2
	
	# Sets the lifetime of the particle system
	smoke_particles.lifetime = exp(-0.01 * propulsion_velocity + 3) + 1

## Clamps the position of the player to stay within the screen
func clamp_position() -> void:
	var padding = 30
	global_position.x = clampf(global_position.x, 0 + padding, 1920 - padding)

## Applies upgrades on game start
func apply_upgrades() -> void:
	# THRUST
	max_thrust = 2.5 * PlayerUpgrades.current_upgrades[PlayerUpgrades.UPGRADES.THRUST]
	# THRUST SPEED
	thrust_velocity = 500 + 250 * PlayerUpgrades.current_upgrades[PlayerUpgrades.UPGRADES.THRUST_SPEED]
	# MAGNET
	magnet_shape.shape.radius = 48 + 32 * PlayerUpgrades.current_upgrades[PlayerUpgrades.UPGRADES.MAGNET] 
	# TURN_SPEED
	turn_speed = 2 + 1 * PlayerUpgrades.current_upgrades[PlayerUpgrades.UPGRADES.TURN_SPEED]
	# LAUNCH VELOCITY
	initial_velocity = 300.0 + 100.0 * PlayerUpgrades.current_upgrades[PlayerUpgrades.UPGRADES.LAUNCH_VELOCITY]
	# INVINCIBILITY THRUST
	hurt_multiplier = 0.5 - 0.25 * PlayerUpgrades.current_upgrades[PlayerUpgrades.UPGRADES.INVINCIBLE_THRUST]
	# BOOST ACCELERATION
	boost_multiplier = 1.0 + 0.25 * PlayerUpgrades.current_upgrades[PlayerUpgrades.UPGRADES.BOOST_ACCELERATION]

## Resets values, and adds the upgrades on game start
func _on_game_start() -> void:
	# Makes sure the correct particle system is playing
	smoke_particles.emitting = true
	death_particles.emitting = false
	
	apply_upgrades()
	
	# Assign values at the start of the game
	global_position = starting_position
	current_thrust = max_thrust
	propulsion_velocity = initial_velocity
	sprite.visible = true
	is_dead = false
	set_collision_layer_value(1, true) # Allow for collisions
	
	# Resets stats to not accumulate over multiple games
	total_distance = 0
	cash_collected = 0

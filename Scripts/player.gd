extends CharacterBody2D
class_name Player

# Child Nodes
@onready var smoke_particles := $"Smoke Particles"
@onready var death_particles := $"Death Particles"
@onready var sprite := $Sprite

# Physics values
@export var initial_velocity := 300.0
@export var speed := 400
var starting_position : Vector2
var propulsion_velocity : float
var outside_velocity := Vector2.ZERO
var scroll_speed : float
const GRAVITY := 10

# Thrust
@export_group("Thrust")
@export var thrust_velocity := 500
@export var max_thrust := 2.5
var current_thrust : float

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
	
	# Thrust handling
	if Input.is_key_pressed(KEY_SPACE) and current_thrust > 0:
		is_thrusting = true
		thrust(delta)
	else:
		is_thrusting = false
	
	apply_gravity(delta)
	movement(delta)
	death_check()
	update_particles()
	
func movement(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction := Vector2(Input.get_axis("ui_left", "ui_right"), 0).normalized()
	
	# Moves in input direction. If no input direction, moves to the zero vector.
	if direction:
		velocity = direction * propulsion_velocity * 2
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	
	# Add in outside velocity and propulsion velocity
	velocity += outside_velocity
	outside_velocity = Vector2.ZERO
	velocity.y -= propulsion_velocity
	
	# Add y velocity to the total distance
	total_distance += velocity.y * delta / 1000
	
	# Put velocity y into scroll speed
	scroll_speed = velocity.y
	velocity.y = 0

	if GameManager.current_game_state == GameManager.GameStates.GAME:
		$ThrustSound.set_parameter("Panning", (global_position.x - 960)/19.2)
		$ThrustSound.play(false)
		print_debug((global_position.x - 960)/19.2)
	
	move_and_slide()

func apply_gravity(delta: float) -> void:
	propulsion_velocity = move_toward(propulsion_velocity, 1, GRAVITY * delta)

func apply_propulsion_velocity(velocity: float) -> void:
	propulsion_velocity += velocity

func apply_velocity(velocity: Vector2) -> void:
	outside_velocity += velocity

func thrust(delta: float) -> void:
	current_thrust = move_toward(current_thrust, 0, delta)
	apply_velocity(Vector2(0, -thrust_velocity))

func death_check() -> void:
	if propulsion_velocity < 100:
		death()

## Player dies
func death() -> void:
	# Temporary behavior
	scroll_speed = 0
	smoke_particles.emitting = false
	death_particles.emitting = true
	sprite.visible = false
	is_dead = true
	
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

## Resets values, and adds the upgrades on game start
func _on_game_start() -> void:
	# Makes sure the correct particle system is playing
	smoke_particles.emitting = true
	death_particles.emitting = false
	
	# Assign values at the start of the game
	global_position = starting_position
	current_thrust = max_thrust
	propulsion_velocity = initial_velocity
	sprite.visible = true
	is_dead = false
	
	# Resets stats to not accumulate over multiple games
	total_distance = 0
	cash_collected = 0
	
	# Apply upgrades
	

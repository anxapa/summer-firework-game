extends CharacterBody2D
class_name Player

# Physics values
@export var propulsion_velocity := 300.0
@export var speed := 400
var outside_velocity := Vector2.ZERO
var scroll_speed : float
var total_distance := 0.0
const GRAVITY := 10

@onready var particle_system := $CPUParticles2D

# Thrust
@export_group("Thrust")
@export var thrust_velocity := 500
@export var max_thrust := 2.5
var current_thrust : float
var is_thrusting := false

func _ready() -> void:
	# Makes sure the particle system is playing
	particle_system.emitting = true
	
	# Sets thrust to full
	current_thrust = max_thrust

func _physics_process(delta: float) -> void:
	# Thrust handling
	if Input.is_key_pressed(KEY_SPACE) and current_thrust > 0:
		is_thrusting = true
		thrust(delta)
	else:
		is_thrusting = false
	
	apply_gravity(delta)
	movement(delta)
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

# Sets the parameters of the particle system depending on propulsion velocity
func update_particles() -> void:
	# Sets the speed of the particle system
	particle_system.initial_velocity_min = propulsion_velocity * 2
	particle_system.initial_velocity_max = propulsion_velocity * 2
	
	# Sets the scale of the particle system
	particle_system.scale_amount_max = (100 / -(propulsion_velocity + 50)) + 4
	particle_system.scale_amount_min = particle_system.scale_amount_max / 2
	
	# Sets the lifetime of the particle system
	particle_system.lifetime = exp(-0.01 * propulsion_velocity + 3) + 0.5

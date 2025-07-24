extends CharacterBody2D
class_name Player

@export var propulsion_velocity := 300.0
var acceleration := Vector2.ZERO
@export var speed := 400
const GRAVITY := 10

var scroll_speed : float

func _ready() -> void:
	return

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	movement(delta)
	
func movement(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction := Vector2(Input.get_axis("ui_left", "ui_right"), 0).normalized()
	
	# Moves in input direction. If no input direction, moves to the zero vector.
	if direction:
		velocity = direction * propulsion_velocity * 2
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	
	# Add in the acceleration and propulsion velocity
	velocity += acceleration;
	velocity.y -= propulsion_velocity
	
	# Put velocity y into scroll speed
	scroll_speed = velocity.y
	velocity.y = 0
	
	move_and_slide()

func apply_gravity(delta: float) -> void:
	propulsion_velocity = move_toward(propulsion_velocity, 0, GRAVITY * delta)

func apply_propulsion_velocity(velocity: float) -> void:
	propulsion_velocity += velocity

extends CharacterBody2D
class_name Player

var acceleration := Vector2.ZERO
@export var speed := 400

var scroll_speed : float

func _ready() -> void:
	return

func _physics_process(delta: float) -> void:
	movement(delta)
	
func movement(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized()
	
	# Moves in input direction. If no input direction, moves to the zero vector.
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	
	# Add in the acceleration
	velocity += acceleration;
	
	# Put velocity y into scroll speed
	scroll_speed = velocity.y
	velocity.y = 0
	
	move_and_slide()

extends Enemy

## For linear movement.
@export var movement_velocity := Vector2(-300, 0)
@export var h_flip := false
@onready var movement_component := $MovementComponent
@onready var sprite := $Airplane

func _ready() -> void:
	super._ready()

	# Flips the bird if it is enabled
	if h_flip:
		flip_h(true)
	else:
		flip_h(false)
	
	# Sets the movement velocity to the movement component for linear motion
	movement_component.movement_velocity = movement_velocity

func flip_h(option : bool) -> void:
		sprite.flip_h = option
		if option:
			movement_velocity.x = abs(movement_velocity.x)
		else:
			movement_velocity.x = -abs(movement_velocity.x)

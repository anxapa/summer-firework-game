extends Enemy

## For linear movement.
@export var movement_velocity := Vector2(-100, 0)

@onready var animation_player := $AnimationPlayer
@onready var movement_component := $MovementComponent

func _ready() -> void:
	super._ready()
	
	# Plays animation for bird flight 
	animation_player.play("flight")
	
	# Sets the movement velocity to the movement component for linear motion
	movement_component.movement_velocity = movement_velocity

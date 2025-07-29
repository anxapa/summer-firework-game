extends Enemy

## Thrust added in seconds when firework is killed by player.
@export var thrust_added := 1.0

# Children
@onready var body_sprite := $"Firework Body Sprite"
@onready var smoke_particles := $"Smoke Particles"
@onready var death_particles := $"Death Particles"

func _ready() -> void:
	super._ready()
	
	# Makes sure the right particles are emitting
	smoke_particles.emitting = true
	death_particles.emitting = false
	
	# Chooses a random color for the body
	body_sprite.self_modulate = choose_random_color()

## Random color function
func choose_random_color() -> Color:
	var color := Color.WHITE
	
	# Select random number
	var x := randf_range(0, 2 * PI)
	
	# Adjust colors to a good-looking one
	color.r = 0.5 + 0.5 * sin(x)
	color.b = 0.5 + 0.5 * sin(x + 2/3 * PI)
	color.g = 0.5 + 0.5 * sin(x + 4/3 * PI)
	
	return color

## Overriding on body entered function to give thrust to player
func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)
	
	if body is Player:
		(body as Player).add_thrust(thrust_added)

## Overriding death function to make it explode
func death() -> void:
	smoke_particles.emitting = false
	death_particles.emitting = true
	body_sprite.visible = false
	
	await get_tree().create_timer(4.0).timeout
	queue_free()

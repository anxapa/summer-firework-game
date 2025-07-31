# TODO: Remove critical sections prior to game launch

class_name Cash 
extends Area2D
@export var cash_value := 1
var is_diamond := false
var starting_position
# false indicates fixed spawn
var spawned = false

@export_category("Textures")
@export var diamond_texture : Texture2D

# Children
@onready var sprite := $Cash
 
#static var scene: PackedScene = load("res://Scenes/cash.tscn")

func _ready() -> void:
	# CRITICAL: remove if condition after deprecating fixed spawns
	if (spawned):
		global_position = starting_position
	
	# Upgrade effect
	convert_to_diamond()

func convert_to_diamond() -> void:
	var diamond_chance := 0.25 * PlayerUpgrades.current_upgrades[PlayerUpgrades.UPGRADES.CASH_DIAMOND]
	
	# If random number is lower than chance, then change the type to diamond
	if randf() < diamond_chance:
		sprite.texture = diamond_texture
		cash_value *= 10
		is_diamond = true

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player and visible:
		GameManager.add_money(cash_value)
		
		# Sound effect played on player
		var player := area.get_parent() as Player
		if is_diamond:
			player.diamond_sound.play(true)
		else:
			player.coin_sound.play(true)
		
		queue_free()

#static func spawn(starting_position: Vector2) -> Cash:
	#var spawn : Cash = scene.instantiate()
	#spawn.spawned = true
	#spawn.starting_position = starting_position - Vector2(0, starting_position.y)
	#return spawn

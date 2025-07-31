extends Node2D
class_name AudioManager
@onready var overworld_music := $"Overworld Music"
@onready var shop_music := $"Shop Music"

# true when impossible to lose (end of game has been reached)
var ending = false

func _ready() -> void:
	GameManager.audio_manager = self

func _physics_process(delta: float) -> void:
	if not ending:
		overworld_music.play(false)
	if GameManager.current_game_state == GameManager.GameStates.SHOP:
		shop_music.play(false)

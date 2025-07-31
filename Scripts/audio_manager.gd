extends Node2D
class_name AudioManager
@onready var overworld_music := $"Overworld Music"
@onready var shop_music := $"Shop Music"
@onready var play_sound := $"Play Sound"
@onready var player := GameManager.player_manager.player

# true when impossible to lose (end of game has been reached)
var ending = false
var checkpoint := 1

func _ready() -> void:
	GameManager.audio_manager = self
	SignalBus.game_start.connect(_on_game_start)

func _physics_process(delta: float) -> void:
	if not ending:
		overworld_music.play(false)
		# conditions for looping song
		if player.total_distance < -50 and not ending:
			ending = true
			overworld_music.set_parameter("Ending", 1)
		elif player.total_distance < -35:
			checkpoint = 3.5
		elif player.total_distance < -20:
			checkpoint = 3
		elif player.total_distance < -10:
			checkpoint = 2
		print_debug(overworld_music.get_parameter("Checkpoint"))
		overworld_music.set_parameter("Checkpoint", checkpoint)
		
	if GameManager.current_game_state == GameManager.GameStates.SHOP:
		shop_music.play(false)

func _on_game_start() -> void:
	play_sound.play()
	shop_music.stop()
	overworld_music.stop()

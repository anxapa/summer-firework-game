# Global name : GameManager
extends Node2D

# Managers (must be set in their respective scripts)
var player_manager : PlayerManager
var spawn_manager: Node2D
var audio_manager: Node2D

# Game stats
var cash_collected := 10

# Game states
enum GameStates {
	MAIN_MENU,
	GAME,
	PAUSED,
	SHOP,
}

var current_game_state := GameStates.GAME

func start_game() -> void:
	# Makes sure the game is not paused
	get_tree().paused = false
	
	# Signal for game start
	current_game_state = GameStates.GAME
	SignalBus.emit_signal("game_start")

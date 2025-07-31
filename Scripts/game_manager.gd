# Global name : GameManager
extends Node2D

# Managers (must be set in their respective scripts)
var player_manager : PlayerManager
var spawn_manager: SpawnManager
var audio_manager: AudioManager

# Game stats
var cash_collected := 100000

# Game states
enum GameStates {
	MAIN_MENU,
	GAME,
	PAUSED,
	SHOP,
}

var current_game_state := GameStates.MAIN_MENU

func start_game() -> void:
	# Makes sure the game is not paused
	get_tree().paused = false
	
	# Signal for game start
	current_game_state = GameStates.GAME
	SignalBus.emit_signal("game_start")

func add_money(money: int) -> void:
	# Cash multiplier from distance
	money *= get_cash_multiplier()
	
	cash_collected += money
	player_manager.player.cash_collected += money

func get_cash_multiplier() -> int:
	return 1 + (int)(-player_manager.player.total_distance / 20)
	

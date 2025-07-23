# Global name : GameManager
extends Node2D

# Managers (must be set in their respective scripts)
var player_manager : PlayerManager
var spawn_manager: Node2D
var audio_manager: Node2D

# Game stats
var cash_collected : float

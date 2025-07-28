extends Panel

var player : Player

# Children nodes
@onready var stat_label := $"Death Panel/Stat Label"
@onready var animation_player := $AnimationPlayer

func _ready() -> void:
	# Get the player node
	player = GameManager.player_manager.player
	
	# Connecting signals
	SignalBus.player_death.connect(_on_player_death)

func update_stats() -> void:
	stat_label.text = "Cash Collected: %d\nTotal Distance: %.1fkm" % [player.cash_collected, -player.total_distance]

func show_death_menu() -> void:
	update_stats()
	animation_player.play("show_menu")
	
	# Wait till animation is finished
	await animation_player.animation_finished
	get_tree().paused = true

func hide_death_menu() -> void:
	animation_player.play("hide_menu")

func _on_player_death() -> void:
	show_death_menu()

func _on_restart_button_pressed() -> void:
	hide_death_menu()
	GameManager.start_game()

func _on_upgrades_button_pressed() -> void:
	hide_death_menu()

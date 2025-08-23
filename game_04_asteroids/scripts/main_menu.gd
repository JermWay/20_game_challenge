extends Control

@onready var ui: Control = $"../UI"
@onready var game: Node = $"../Game"

func _on_start_button_pressed() -> void:
	visible = false
	ui.visible = true
	game.spawn_player_ship()

extends Node

@export var player_ship_scene: PackedScene

var player_ship: Area2D

@onready var ui: Control = $"../UI"
@onready var asteroids: Node = $Asteroids

func spawn_player_ship() -> void:
	player_ship = player_ship_scene.instantiate()
	player_ship.died.connect(ui.lives.remove_life)
	player_ship.bullet_pool = $BulletPool
	add_child(player_ship)

func free_ship() -> void:
	player_ship.queue_free()

func _on_restart_button_pressed() -> void:
	ui.game_over_panel.visible = false
	ui.reset_ui()
	asteroids.reset()
	spawn_player_ship()

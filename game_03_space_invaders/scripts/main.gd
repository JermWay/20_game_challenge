extends Node2D

@export var player_scene: PackedScene
@onready var screen_rect: Rect2 = get_viewport().get_visible_rect()
@onready var projectile_manager: Node2D = $ProjectileManager
@onready var ui: Control = $UI
@onready var alien_manager: Node2D = $AlienManager

var player: CharacterBody2D
var player_movement_rect: Rect2

func _ready() -> void:
	player = player_scene.instantiate()
	player_movement_rect.size.x = screen_rect.size.x
	player_movement_rect.size.y = screen_rect.size.y * .2
	
	player_movement_rect.position.y = screen_rect.size.y - player_movement_rect.size.y
	
	player.position = player_movement_rect.position + (player_movement_rect.size / 2)
	
	player.movement_limits = player_movement_rect
	player.rocket_manager = projectile_manager
	player.ui = ui
	player.connect("player_hit", alien_manager.on_player_hit)
	player.connect("player_spawn", alien_manager.on_player_spawn)
	add_child(player)

extends Node2D

@export var player_scene: PackedScene
@onready var player: CharacterBody2D
@onready var screen_rect: Rect2 = get_viewport().get_visible_rect()

var player_movement_rect: Rect2

func _ready() -> void:
	print(screen_rect)
	player = player_scene.instantiate()
	player_movement_rect.size.x = screen_rect.size.x
	player_movement_rect.size.y = screen_rect.size.y * .2
	
	player_movement_rect.position.y = screen_rect.size.y - player_movement_rect.size.y
	
	print(player_movement_rect)
	player.position = player_movement_rect.position + (player_movement_rect.size / 2)
	add_child(player)

func _physics_process(delta: float) -> void:
	if not player.is_node_ready():
		return
	handle_input(delta)

func handle_input(delta: float) -> void:
		
	var move_direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		move_direction += Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("move_down"):
		move_direction += Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		move_direction += Vector2.UP
	
	move_direction.normalized()

	player.move_player(move_direction, delta, player_movement_rect)

extends CharacterBody2D

@export var paddle_speed: float = 200

@onready var extents = $CollisionShape2D.shape.extents

func move_paddle(move_direction: Vector2, delta: float, screen_size: Vector2) -> void:
	position += move_direction * delta * paddle_speed
	position = position.clamp(
		extents,
		screen_size - extents
	)

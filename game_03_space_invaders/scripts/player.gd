extends CharacterBody2D

@export var player_speed: float = 200

@onready var extents = $CollisionShape2D.shape.extents
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func move_player(move_direction: Vector2, delta: float, constrants: Rect2) -> void:
	position += move_direction * delta * player_speed
	position = position.clamp(
		constrants.position + extents,
		constrants.position + constrants.size - extents
	)
	
	if move_direction != Vector2.ZERO:
		sprite_2d.play("default")
	else:
		sprite_2d.stop()

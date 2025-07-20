extends CharacterBody2D

@export var player_speed: float = 200
@export var rocket_scene: PackedScene

@onready var extents = $CollisionShape2D.shape.extents
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var rocket: CharacterBody2D

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

func fire(manager: Node2D) -> void:
	rocket = rocket_scene.instantiate()
	rocket.position = position
	rocket.position.y -= extents.y
	manager.add_child(rocket)

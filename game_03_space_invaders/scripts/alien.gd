extends StaticBody2D

@export var bomb_scene: PackedScene

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var bomb: CharacterBody2D
var radius

func _ready() -> void:
	radius = collision_shape_2d.shape.radius
	
func connect_move_signal(manager: Node2D) -> void:
	manager.connect("alien_moved", _moved)

func _moved() -> void:
	animated_sprite_2d.frame = (animated_sprite_2d.frame + 1) % 3
	
func fire(manager: Node2D) -> void:
	bomb = bomb_scene.instantiate()
	bomb.global_position = global_position
	bomb.global_position.y += radius
	manager.add_child(bomb)

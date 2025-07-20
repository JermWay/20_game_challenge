extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var radius
func _ready() -> void:
	radius = collision_shape_2d.shape.radius
	
func connect_move_signal() -> void:
	get_parent().connect("alien_moved", _moved)

func _moved() -> void:
	animated_sprite_2d.frame = (animated_sprite_2d.frame + 1) % 3
	

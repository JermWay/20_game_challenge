extends Area2D

@export var next_asteroid_scene: PackedScene
@export var speed: float = 200

var direction: Vector2 = Vector2.ZERO
func _ready() -> void:
	pick_random_position()
	pick_random_direction()
	
func _physics_process(delta: float) -> void:
	position += direction.normalized() * speed * delta
	
func pick_random_direction() -> void:
	direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	
func pick_random_position() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	var screen_side = randi() % 4
	match screen_side:
		0:
			global_position = Vector2(randf() * viewport_size.x, 0)
		1:
			global_position = Vector2(viewport_size.x, randf() * viewport_size.y)
		2:
			global_position = Vector2(randf() * viewport_size.x, viewport_size.y)
		3:
			global_position = Vector2(0, randf() * viewport_size.y)

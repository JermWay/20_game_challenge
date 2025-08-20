extends Area2D
class_name Asteroid

@export var next_asteroid_scene: PackedScene
@export var speed: float = 200

var direction: Vector2 = Vector2.ZERO
var size: Vector2
	
func _physics_process(delta: float) -> void:
	position += direction.normalized() * speed * delta
	
func initialize_asteroid(start_position: Vector2, start_direction: Vector2) -> void:
	size = Vector2($CollisionShape2D.shape.radius, $CollisionShape2D.shape.radius) * global_scale
	direction = start_direction
	position = start_position
	
func pick_random_direction() -> Vector2:
	return Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	
func pick_random_position() -> Vector2:
	var viewport_size: Vector2 = get_viewport_rect().size
	var screen_side = randi() % 4
	match screen_side:
		0:
			return Vector2(randf() * viewport_size.x, 0 - size.y)
		1:
			return Vector2(viewport_size.x + size.x, randf() * viewport_size.y)
		2:
			return Vector2(randf() * viewport_size.x, viewport_size.y + size.y)
		3:
			return Vector2(0 - size.x, randf() * viewport_size.y)
		_:
			return Vector2.ZERO


func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		if not area.visible:
			return
		print(area.name)
		call_deferred("explode", area)
		
func explode(area: Bullet) -> void:
	area.stop()
	if next_asteroid_scene == null:
		queue_free()
	else:
		var new_asteroid: Asteroid = next_asteroid_scene.instantiate()
		new_asteroid.initialize_asteroid(global_position + size, direction.rotated(deg_to_rad(45 + randf_range(-10,10))).normalized())
		get_parent().add_child(new_asteroid)
		new_asteroid = next_asteroid_scene.instantiate()
		new_asteroid.initialize_asteroid(global_position - size, direction.rotated(deg_to_rad(-45 + randf_range(-10,10))).normalized())
		get_parent().add_child(new_asteroid)
		queue_free()

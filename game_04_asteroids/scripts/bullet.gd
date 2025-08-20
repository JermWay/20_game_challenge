extends Area2D
class_name Bullet

@export var bullet_speed: float = 200

var is_moving = false
var distance_traveled = 0

func _physics_process(delta: float) -> void:
	move(delta)

func move(delta: float) -> void:
	if is_moving:
		distance_traveled += bullet_speed * delta
		position += Vector2.UP.rotated(rotation) * bullet_speed * delta
		var viewport_size = get_viewport_rect().size
		if distance_traveled > min(viewport_size.x, viewport_size.y) * .33:
			stop()

func fire(start_position: Vector2, start_rotation: float) -> void:
	global_position = start_position
	global_rotation = start_rotation
	visible = true
	is_moving = true
	distance_traveled = 0

func stop() -> void:
	is_moving = false
	visible = false
	

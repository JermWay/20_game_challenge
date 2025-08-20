extends Node

@export var collider: Node

var half_size: Vector2
@onready var parent: Node = get_parent()
@onready var viewport_size: Vector2 = parent.get_viewport_rect().size

func _ready() -> void:
	if collider != null:
		print(collider.get_class())
		if collider is CollisionPolygon2D:
			half_size = get_polygon_half_size(collider)
		elif collider is CollisionShape2D:
			if collider.shape is RectangleShape2D:
				half_size = collider.shape.extents
			elif collider.shape is CircleShape2D:
				half_size = Vector2(collider.shape.radius, collider.shape.radius)
	
func _physics_process(_delta: float) -> void:
	screen_wrap_position()
	
func screen_wrap_position() -> void:
	parent.global_position.x = wrapf(parent.global_position.x, 0 - half_size.x, viewport_size.x + half_size.x)
	parent.global_position.y = wrapf(parent.global_position.y, 0 - half_size.y, viewport_size.y + half_size.y)

func get_polygon_half_size(polygon_collider: CollisionPolygon2D) -> Vector2:
	var polygon:PackedVector2Array = polygon_collider.polygon
	var min_x = polygon[0].x
	var min_y = polygon[0].y
	var max_x = polygon[0].x
	var max_y = polygon[0].y
	for point in polygon:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
		
	return Vector2(max_x - min_x, max_y - min_y) / 2

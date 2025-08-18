extends Node

@export var bullet_scene: PackedScene

var next_bullet_index: int = 0
var bullet_pool_size: int = 4

func _ready() -> void:
	var bullet: Bullet
	for index in range(bullet_pool_size):
		bullet = bullet_scene.instantiate()
		bullet.visible = false
		add_child(bullet)
		
func fire(global_position: Vector2, rotation: float) -> void:
	var bullet := get_child(next_bullet_index)
	bullet.fire(global_position, rotation)
	next_bullet_index = wrapi(next_bullet_index + 1, 0, get_child_count())

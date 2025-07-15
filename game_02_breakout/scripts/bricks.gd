extends Node

@export var brick_scene: PackedScene

func setup_bricks() -> void:
	var last_brick_position: Vector2 = Vector2(0,80)
	var brick_extents
	for rows in range(8):
		for cols in range(16):
			var brick: StaticBody2D = brick_scene.instantiate()
			brick_extents = brick.get_node("CollisionShape2D").shape.extents
			brick.position = last_brick_position + brick_extents
			last_brick_position.x = brick.position.x + brick_extents.x
			add_child(brick)
		last_brick_position.y += brick_extents.y * 2
		last_brick_position.x = 0
	

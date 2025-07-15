extends Node

@export var brick_scene: PackedScene

func setup_bricks() -> void:
	var last_brick_position: Vector2 = Vector2(0,80)
	var brick_extents
	var brick_color: Color = Color.WHITE
	var brick_points: int = 0
	
	for rows in range(8):
		var row_color = rows /2
		match row_color:
			2: brick_color = Color.GREEN
			0: brick_color = Color.RED
			1: brick_color = Color.ORANGE
			3: brick_color = Color.YELLOW
			_: brick_color = Color.WHITE
		match row_color:
			0: brick_points = 7
			1: brick_points = 5
			2: brick_points = 3
			3: brick_points = 1
			_: brick_points = 0
			
		for cols in range(16):
			var brick: StaticBody2D = brick_scene.instantiate()
			brick_extents = brick.get_node("CollisionShape2D").shape.extents
			brick.position = last_brick_position + brick_extents
			last_brick_position.x = brick.position.x + brick_extents.x
			brick.modulate = brick_color
			brick.points = brick_points
			add_child(brick)
		last_brick_position.y += brick_extents.y * 2
		last_brick_position.x = 0
	

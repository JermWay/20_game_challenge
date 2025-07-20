extends Node2D

signal alien_moved

@export var alien_scene: PackedScene

var direction := 1
var is_at_edge := false
var alien_group_rect: Rect2

func _ready() -> void:
	for row in range(4):
		for col in range(6):
			var alien := alien_scene.instantiate()
			var spacing := Vector2(16,8)
			alien.position = Vector2(
				col * (32 + spacing.x),
				row * (32 + spacing.y)
			)
			alien.position += Vector2(16,16)

			add_child(alien)
			alien.connect_move_signal()
	update_size()

func move_aliens() -> void:
	var move_step := (12.5)
	var new_position := position.x + (move_step * direction)
	if new_position + alien_group_rect.size.x  > get_viewport_rect().size.x or new_position < 0:
		position.y += 40
		direction *= -1
	else:
		position.x = new_position
	alien_moved.emit()
	

func update_size() -> void:
	var lowest_position := get_viewport_rect().size
	var highest_position := Vector2.ZERO
	for child in get_children():
		if child is StaticBody2D:
			if child.position.x < lowest_position.x:
				lowest_position.x = child.position.x
			if child.position.x > highest_position.x:
				highest_position.x = child.position.x
			if child.position.y < lowest_position.y:
				lowest_position.y = child.position.y
			if child.position.y > highest_position.y:
				highest_position.y = child.position.y
	alien_group_rect.size = highest_position-lowest_position
	alien_group_rect.size += Vector2(32,32)
	alien_group_rect.position = position - Vector2(16,16)
	
func _on_timer_timeout() -> void:
	move_aliens()

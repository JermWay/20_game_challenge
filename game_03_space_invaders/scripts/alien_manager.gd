extends Node2D

signal alien_moved

@export var alien_scene: PackedScene
@onready var alien_group: Node = $AlienGroup
@onready var projectile_manager: Node2D = $"../ProjectileManager"

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

			alien_group.add_child(alien)
			alien.connect_move_signal(self)
	update_size()

func aliens_in_bottom_row() -> Array:
	var bottom_row: Array = []
	var aliens_alive := alien_group.get_children()
	aliens_alive.reverse()
	for child in aliens_alive:
		if bottom_row.size() == 0:
			bottom_row.append(child)
		elif child.position.y == bottom_row[-1].position.y:
			bottom_row.append(child)
	return bottom_row
		
func move_aliens() -> void:
	var move_step := (12.5)
	var new_position := position.x + (move_step * direction)
	if new_position + alien_group_rect.size.x  > get_viewport_rect().size.x or new_position < 0:
		position.y += 40
		direction *= -1
	else:
		position.x = new_position
	alien_moved.emit()
	aliens_in_bottom_row().pick_random().fire(projectile_manager)
	

func update_size() -> void:
	var lowest_position := get_viewport_rect().size
	var highest_position := Vector2.ZERO
	for child in alien_group.get_children():
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

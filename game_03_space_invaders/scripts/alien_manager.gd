extends Node2D

signal alien_moved

@export var alien_scene: PackedScene
@onready var alien_group: Node2D = $AlienGroup
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
	var move_step := 12.5
	var new_position := move_step * direction
	
	if is_new_position_on_screen(new_position):
		alien_group.position.x += new_position
	else:	
		alien_group.position.y += 40
		direction *= -1
	
	alien_moved.emit()
	aliens_in_bottom_row().pick_random().fire(projectile_manager)
	
func is_new_position_on_screen(move_step) -> bool:
	for alien in alien_group.get_children():
		if alien is Area2D:
			if alien.global_position.x + move_step < 16 or alien.global_position.x + move_step > get_viewport_rect().size.x - 16:
				return false
	return true
	
func _on_timer_timeout() -> void:
	if alien_group.get_child_count() > 0:
		move_aliens()

extends Node2D

signal alien_moved

@export var alien_scene: PackedScene
@onready var alien_group: Node2D = $AlienGroup
@onready var projectile_manager: Node2D = $"../ProjectileManager"

var direction := 1
var is_at_edge := false
var alien_group_rect: Rect2
var pause_movement: bool = false

func _ready() -> void:
	for col in range(6):
		var column = Node2D.new()
		column.name = "column%s" % str(col)
		alien_group.add_child(column)
		for row in range(4):
			var alien := alien_scene.instantiate()
			var spacing := Vector2(16,8)
			alien.position = Vector2(
				col * (32 + spacing.x),
				row * (32 + spacing.y)
			)
			alien.position += Vector2(16,16)

			column.add_child(alien)
			alien.connect_move_signal(self)

func aliens_in_bottom_row() -> Array:
	var bottom_row: Array = []
	var aliens_alive := alien_group.get_children()
	for child in aliens_alive:
		if child.get_child_count() > 0:
			bottom_row.append(child.get_child(-1))
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
	for column in alien_group.get_children():
		for alien in column.get_children():
			if alien is Area2D:
				if alien.global_position.x + move_step < 16 or alien.global_position.x + move_step > get_viewport_rect().size.x - 16:
					return false
	return true
	
func _on_timer_timeout() -> void:
	if alien_group.get_child_count() > 0 and not pause_movement:
		move_aliens()
	
func on_player_spawn() -> void:
	await get_tree().create_timer(1).timeout
	pause_movement = false
	
func on_player_hit() -> void:
	pause_movement = true
	

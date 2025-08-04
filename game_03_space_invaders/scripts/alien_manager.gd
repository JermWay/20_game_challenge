extends Node2D

signal alien_moved

@export var alien_01_scene: PackedScene
@export var alien_02_scene: PackedScene

@onready var alien_group: Node2D = $AlienGroup
@onready var projectile_manager: Node2D = $"../ProjectileManager"
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var move_timer: Timer = $MoveTimer
@onready var fire_timer: Timer = $FireTimer

var direction := 1
var is_at_edge := false
var alien_group_rect: Rect2
var pause_movement: bool = false
var alien_start_count: float = 0.0
const COL: int = 6
const ROW: int = 4

func _ready() -> void:
	initalize_alien_group()
		
func initalize_alien_group() -> void:
	for col in range(COL):
		var column = Node2D.new()
		column.name = "column%s" % str(col)
		alien_group.add_child(column)
		for row in range(ROW):
			var alien
			if row % 2 == 0:
				alien = alien_01_scene.instantiate()
			else:
				alien = alien_02_scene.instantiate()
			var spacing := Vector2(16,8)
			alien.position = Vector2(
				col * (32 + spacing.x),
				row * (32 + spacing.y)
			)
			alien.position += Vector2(16,16)

			column.add_child(alien)
			alien_start_count += 1
			alien.connect_move_signal(self)

func _process(_delta: float) -> void:
	if is_alien_at_bottom():
		get_tree().call_deferred("reload_current_scene")

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
	
	audio_stream_player.play()
	alien_moved.emit()

func is_alien_at_bottom() -> bool:
	for column in alien_group.get_children():
		for alien in column.get_children():
			if alien is Area2D:
				if alien.global_position.y > get_viewport_rect().size.y:
					return true
	return false
	
func is_new_position_on_screen(move_step) -> bool:
	for column in alien_group.get_children():
		for alien in column.get_children():
			if alien is Area2D:
				if alien.global_position.x + move_step < 16 or alien.global_position.x + move_step > get_viewport_rect().size.x - 16:
					return false
	return true
	
func _on_move_timer_timeout() -> void:
	if get_alien_count() > 0 and not pause_movement:
		move_aliens()
		move_timer.start(get_alien_count()/alien_start_count)
		audio_stream_player.pitch_scale = 1 + get_alien_count() / alien_start_count
	
func on_player_spawn() -> void:
	await get_tree().create_timer(1).timeout
	pause_movement = false
	
func on_player_hit() -> void:
	pause_movement = true
	
func get_alien_count() -> float:
	var alien_count: float = 0
	for column in alien_group.get_children():
		for alien in column.get_children():
			if alien is Area2D:
				alien_count += 1
	return alien_count
	


func _on_fire_timer_timeout() -> void:
	fire_timer.wait_time = randf() * 3.0
	aliens_in_bottom_row().pick_random().fire(projectile_manager)
	fire_timer.start()

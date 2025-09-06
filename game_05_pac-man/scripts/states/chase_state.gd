extends State

var is_moving = false
var previous_tile: Vector2i
var current_tile: Vector2i
var next_tile: Vector2i
var path: Array[Vector2i] = []
@onready var maze: TileMapLayer = $"../../../Maze"
@onready var pac_man: AnimatedSprite2D = $"../../../PacMan"
@onready var ghost_red: Sprite2D = $"../.."

func enter() -> void:
	current_tile = maze.global_to_tile(ghost_red.global_position)
	if not is_centered_on_tile():
		ghost_red.global_position = maze.tile_to_global(current_tile)
			
func update(_delta: float) -> void:
	if not is_moving and is_centered_on_tile():
		if path.size() <= 1 or maze.is_intersection(current_tile):
			var target_tile = maze.global_to_tile(pac_man.global_position)
			if target_tile == current_tile:
				return
			path = maze.find_path(current_tile, target_tile, previous_tile)
		
		if path.size() > 1:
			next_tile = path[1]
			path.remove_at(0)
			
		if next_tile != null or next_tile != current_tile:
			if current_tile.distance_to(next_tile) > 1:
				warp_move()
			else:
				move_to_next_tile()

func warp_move() -> void:
	if is_moving:
		return
	is_moving = true
	
	if current_tile.x < next_tile.x:
		var off_screen_tile_left := current_tile + Vector2i.LEFT
		tween_to_tile(off_screen_tile_left, _on_moved_off_screen_left_for_warp)
	else:
		var off_screen_tile_right := current_tile + Vector2i.RIGHT
		tween_to_tile(off_screen_tile_right, _on_moved_off_screen_right_for_warp)

		
func _on_moved_off_screen_right_for_warp() -> void:
	var off_screen_tile_left := next_tile + Vector2i.LEFT
	ghost_red.global_position = maze.tile_to_global(off_screen_tile_left)
	tween_to_tile(next_tile, _on_move_completed)
		
func _on_moved_off_screen_left_for_warp() -> void:
	var off_screen_tile_right := next_tile + Vector2i.RIGHT
	ghost_red.global_position = maze.tile_to_global(off_screen_tile_right)
	tween_to_tile(next_tile, _on_move_completed)

func move_to_next_tile() -> void:
	if is_moving:
		return
	is_moving = true
	tween_to_tile(next_tile, _on_move_completed)
	
func tween_to_tile(tile: Vector2i, callback: Callable) -> void:
	var move_tween := create_tween()
	move_tween.tween_property(ghost_red, "global_position", maze.tile_to_global(tile), 0.1)
	move_tween.tween_callback(callback)
	
func _on_move_completed() -> void:
	previous_tile = current_tile
	current_tile = maze.global_to_tile(ghost_red.global_position)
	is_moving = false
	
func is_centered_on_tile() -> bool:
	var tile_center: Vector2 = maze.tile_to_global(current_tile)
	return ghost_red.global_position.distance_to(tile_center) < 1.0

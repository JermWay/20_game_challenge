extends Sprite2D

var is_moving = false
var previous_tile: Vector2i
var current_tile: Vector2i
var next_tile: Vector2i
var path: Array[Vector2i] = []

@onready var maze: TileMapLayer = $"../Maze"
@onready var pac_man: AnimatedSprite2D = $"../PacMan"

func _ready() -> void:
	current_tile = maze.global_to_tile(global_position)
	if not is_centered_on_tile():
		move(current_tile)
			
func _physics_process(delta: float) -> void:
	if is_moving:
		return
	
	if is_centered_on_tile():
		
		if path.size() <= 1 or maze.is_intersection(current_tile):
			var target_tile = maze.global_to_tile(pac_man.global_position)
			if target_tile == current_tile:
				print("caught")
				return
			path = maze.find_path(current_tile, target_tile, previous_tile)
		
		if path.size() > 1:
			next_tile = path[1]
			
		if path.size() > 1:
			next_tile = path[1]
			path.remove_at(0)
			move(next_tile)

func move(move_to: Vector2i) -> void:
	if is_moving:
		return
		
	is_moving = true
	var target = maze.tile_to_global(move_to)
	var move_tween = create_tween()
	move_tween.tween_property(self, "global_position", target,.1)
	move_tween.tween_callback(_on_move_completed)
	
func _on_move_completed() -> void:
	previous_tile = current_tile
	current_tile = maze.global_to_tile(global_position)
	is_moving = false
	
func is_centered_on_tile() -> bool:
	var tile_center = maze.tile_to_global(current_tile)
	return global_position.distance_to(tile_center) < 1.0

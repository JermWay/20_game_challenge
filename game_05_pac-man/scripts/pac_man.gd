extends AnimatedSprite2D
@onready var maze: TileMapLayer = $"../Maze"
var move_to: Vector2i
var is_moving: bool

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		move_to = maze.local_to_map(position) + Vector2i.LEFT
		move()
	elif Input.is_action_pressed("ui_right"):
		move_to = maze.local_to_map(position) + Vector2i.RIGHT
		move()
	elif Input.is_action_pressed("ui_up"):
		move_to = maze.local_to_map(position) + Vector2i.UP
		move()
	elif Input.is_action_pressed("ui_down"):
		move_to = maze.local_to_map(position) + Vector2i.DOWN
		move()
	if is_moving and not is_playing():
		play()
	if not is_moving:
		pause()

func move() -> void:
	if is_moving:
		return
		
	var tile = maze.get_cell_tile_data(move_to)
	if tile != null and tile.get_custom_data("is_wall"):
			return
			
	is_moving = true
	var move_tween = create_tween()
	move_tween.tween_property(self, "position", maze.map_to_local(move_to),.1)
	
	move_tween.tween_callback(func(): is_moving = false)

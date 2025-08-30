extends AnimatedSprite2D
signal scored(points: int)

@onready var maze: TileMapLayer = $"../Maze"

var move_to: Vector2i
var is_moving: bool

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		move_to = maze.global_to_tile(global_position) + Vector2i.LEFT
		rotation = deg_to_rad(180)
		move()
	elif Input.is_action_pressed("ui_right"):
		move_to = maze.global_to_tile(global_position) + Vector2i.RIGHT
		rotation = deg_to_rad(0)
		move()
	elif Input.is_action_pressed("ui_up"):
		move_to = maze.global_to_tile(global_position) + Vector2i.UP
		rotation = deg_to_rad(-90)
		move()
	elif Input.is_action_pressed("ui_down"):
		move_to = maze.global_to_tile(global_position) + Vector2i.DOWN
		rotation = deg_to_rad(90)
		move()
	if is_moving and not is_playing():
		play()
	if not is_moving:
		pause()

func move() -> void:
	if is_moving:
		return
		
	var data = maze.get_cell_tile_data(move_to)
	if data != null:
		if data.get_custom_data("is_wall"):
			return
			
	is_moving = true
	var move_tween = create_tween()
	move_tween.tween_property(self, "global_position", maze.tile_to_global(move_to),.1)
	if data != null: 
		if data.get_custom_data("has_dot"):
			move_tween.tween_callback(eat_dot.bind(move_to))
		elif data.get_custom_data("has_power_pellet"):
			move_tween.tween_callback(eat_power_pellet.bind(move_to))
	move_tween.tween_callback(func(): is_moving = false)

func eat_dot(dot_pos: Vector2i) -> void:
	scored.emit(10)
	maze.set_cell(dot_pos, 0, Vector2i(3,0), 0)
	
func eat_power_pellet(dot_pos: Vector2i) -> void:
	scored.emit(50)
	maze.set_cell(dot_pos, 0, Vector2i(3,0), 0)

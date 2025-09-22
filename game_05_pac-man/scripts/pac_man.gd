extends AnimatedSprite2D
signal scored(points: int)

@export var start_marker: Marker2D
@onready var maze: TileMapLayer = $"../Maze"

var target_tile: Vector2i
var input_buffer: Vector2i = Vector2i.ZERO
var move_dir: Vector2i = Vector2i.ZERO
var is_moving: bool
var start_tile: Vector2i

func _ready() -> void:
	global_position = start_marker.global_position
	
func _process(_delta: float) -> void:
	update_input_buffer()
	handle_move()
	update_animation()
	
func update_animation():
	if is_moving and not is_playing():
		play()
	if not is_moving:
		pause()
		
func update_input_buffer() -> void:
	if Input.is_action_pressed("ui_left"):
		input_buffer = Vector2i.LEFT
	elif Input.is_action_pressed("ui_right"):
		input_buffer = Vector2i.RIGHT
	elif Input.is_action_pressed("ui_up"):
		input_buffer = Vector2i.UP
	elif Input.is_action_pressed("ui_down"):
		input_buffer = Vector2i.DOWN
	
func handle_move() -> void:
	if is_moving:
		return
		
	if input_buffer != Vector2i.ZERO:
		if not maze.is_wall(maze.global_to_tile(global_position) + input_buffer):
			move_dir = input_buffer
			input_buffer = Vector2i.ZERO
	
	match move_dir:
		Vector2i.LEFT:
			rotation = deg_to_rad(180)
		Vector2i.RIGHT:
			rotation = deg_to_rad(0)
		Vector2i.UP:
			rotation = deg_to_rad(-90)
		Vector2i.DOWN:
			rotation = deg_to_rad(90)
			
	target_tile = maze.global_to_tile(global_position) + move_dir

	if maze.is_wall(target_tile):
		return
			
	if target_tile.x != (target_tile.x + maze.width) % maze.width:
		target_tile.x = (target_tile.x + maze.width) % maze.width

		if target_tile.x == 0 :
			global_position = maze.tile_to_global(target_tile + Vector2i.LEFT)
		elif target_tile.x == maze.width - 1:
			global_position = maze.tile_to_global(target_tile + Vector2i.RIGHT)
		
	is_moving = true
	
	var move_tween = create_tween()
	move_tween.tween_property(self, "global_position", maze.tile_to_global(target_tile),.1)
	move_tween.tween_callback(move_finished)

func move_finished() -> void:
	var current_tile = maze.global_to_tile(global_position)
	var data = maze.get_cell_tile_data(current_tile)
	if data != null: 
		if data.get_custom_data("has_dot"):
			eat_dot(current_tile)
		elif data.get_custom_data("has_power_pellet"):
			eat_power_pellet(current_tile)
	is_moving = false
	
func eat_dot(dot_pos: Vector2i) -> void:
	scored.emit(10)
	maze.set_cell(dot_pos, 0, Vector2i(3,0), 0)
	maze.get_cell_tile_data(dot_pos).set_custom_data("has_dot", false)
	
func eat_power_pellet(dot_pos: Vector2i) -> void:
	scored.emit(50)
	maze.set_cell(dot_pos, 0, Vector2i(3,0), 0)

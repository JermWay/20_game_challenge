extends Node

@export var ball_scene: PackedScene

@onready var score: Label = $Board/Score
@onready var lives: Label = $Board/Lives
@onready var paddle: CharacterBody2D = $Paddle
@onready var bottom_wall: StaticBody2D = $Walls/Bottom

@export var lives_count: int = 3
@export var ball_speed: float = 400

var ball: RigidBody2D
var ball_start_position: Vector2
var paddle_start_position: Vector2
var score_count: int = 0
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	paddle_start_position = Vector2(
		screen_size.x / 2,
		screen_size.y * .9
	)
	ball_start_position = Vector2(
		paddle_start_position.x,
		paddle_start_position.y - paddle.extents.y
	)
	
	reset_ball()
	$Bricks.setup_bricks()
	
func _physics_process(delta: float) -> void:
	handle_input(delta)

func handle_input(delta: float) -> void:
	var move_direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("right"):
		move_direction += Vector2.RIGHT
	if Input.is_action_pressed("left"):
		move_direction += Vector2.LEFT
		
	paddle.move_paddle(move_direction, delta, screen_size)
	

func reset_ball() -> void:
	paddle.position = paddle_start_position
	if ball:
		if ball.body_entered.is_connected(_on_ball_hit_wall):
			ball.body_entered.disconnect(_on_ball_hit_wall)
		ball.queue_free()
		
	ball = ball_scene.instantiate()
	ball.global_position = ball_start_position
	
	ball.linear_velocity = Vector2.UP.normalized() * ball_speed
	ball.body_entered.connect(_on_ball_hit_wall)
	add_child(ball)
	
func _on_ball_hit_wall(body: Node) -> void:
	if body == bottom_wall:
		lives_count -= 1
		lives.text = str(lives_count)
		reset_ball.call_deferred()
	elif body == paddle:
		var offset = (ball.global_position.x - paddle.global_position.x) / paddle.extents.x
		var direction = Vector2(offset, -1).normalized()
		ball.linear_velocity = direction * ball_speed

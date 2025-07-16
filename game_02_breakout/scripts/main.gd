extends Node

@export var ball_scene: PackedScene

@onready var high_score: Label = $Board/HighScore
@onready var score: Label = $Board/Score
@onready var lives: Label = $Board/Lives
@onready var paddle: CharacterBody2D = $Paddle
@onready var bottom_wall: StaticBody2D = $Walls/Bottom
@onready var brick_manager: Node = $BrickManager
@onready var paddle_bounce: AudioStreamPlayer = $PaddleBounce
@onready var brick_bounce: AudioStreamPlayer = $BrickBounce

@export var max_lives: int = 3
@export var ball_start_speed: float = 400
var ball_speed: float

var ball: RigidBody2D
var paddle_start_position: Vector2
var screen_size: Vector2
var disable_paddle: bool = false

var lives_count: int = 0: 
		set(new_value):
			lives_count = new_value
			lives.text = str(lives_count)
		get: 
			return lives_count
var score_count: int = 0:
		set(new_value):
			score_count = new_value
			score.text = str(score_count)
		get: 
			return score_count
var high_score_count: int = 0:
		set(new_value):
			high_score_count = new_value
			high_score.text = str(high_score_count)
		get: 
			return high_score_count


func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	paddle_start_position = Vector2(
		screen_size.x / 2,
		screen_size.y * .9
	)
	
	reset_game()
	
func reset_game() -> void:
	if score_count > high_score_count:
		high_score_count = score_count
	score_count = 0
	lives_count = 1
	reset_ball()
	brick_manager.reset_bricks()
	
func _physics_process(delta: float) -> void:
	if disable_paddle and ball.get_parent() == paddle:
		disable_paddle = false
	if not disable_paddle:
		handle_input(delta)

func handle_input(delta: float) -> void:
	if disable_paddle:
		return
		
	var move_direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("right"):
		move_direction += Vector2.RIGHT
	if Input.is_action_pressed("left"):
		move_direction += Vector2.LEFT
	if Input.is_action_just_pressed("ui_accept"):
		if ball.linear_velocity == Vector2.ZERO:
			ball.reparent(paddle.get_parent())
			ball.freeze = false
			ball.linear_velocity = Vector2.UP.normalized() * ball_speed
			
	paddle.move_paddle(move_direction, delta, screen_size)
	
func reset_ball() -> void:
	disable_paddle = true
	
	if ball:
		if ball.body_entered.is_connected(_on_ball_hit_wall):
			ball.body_entered.disconnect(_on_ball_hit_wall)
		ball.queue_free()
		
	paddle.global_position = paddle_start_position
	
	ball = ball_scene.instantiate()
	ball_speed = ball_start_speed
	ball.body_entered.connect(_on_ball_hit_wall)
	
	paddle.add_child(ball)
	var offset = Vector2(0,-10)
	ball.position = offset
	
func _on_ball_hit_wall(body: Node) -> void:
	if body == bottom_wall:
		lives_count += 1
		if lives_count > 3:
			reset_game()
			return
		reset_ball.call_deferred()
	elif body == paddle:
		paddle_bounce.play()
		var offset = (ball.global_position.x - paddle.global_position.x) / paddle.extents.x
		var direction = Vector2(offset, -1).normalized()
		ball.linear_velocity = direction * ball_speed
	elif body.is_in_group("bricks"):
		brick_bounce.play()
		score_count += body.points
		body.queue_free()
		ball_speed += 10

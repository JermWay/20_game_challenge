extends Node

@export var ball_scene: PackedScene

@onready var ball: RigidBody2D
@onready var left_score: Label = $Board/LeftScore
@onready var right_score: Label = $Board/RightScore
@onready var right_paddle: CharacterBody2D = $RightPaddle
@onready var left_paddle: CharacterBody2D = $LeftPaddle
@onready var left: CharacterBody2D = $Walls/Left
@onready var right: CharacterBody2D = $Walls/Right

var ball_start_position: Vector2
var left_score_count: int = 0
var right_score_count: int = 0
var ball_speed = 400
var paddle_speed = 200
var screen_size: Vector2
var paddle_size: Vector2

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	paddle_size = $RightPaddle/CollisionShape2D.shape.extents
	ball_start_position = screen_size / 2
	reset_ball()
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("left_down"):
		left_paddle.position.y += paddle_speed * delta
	if Input.is_action_pressed("left_up"):
		left_paddle.position.y -= paddle_speed * delta
	left_paddle.position = left_paddle.position.clamp(Vector2.ZERO+paddle_size,screen_size-paddle_size)
	if Input.is_action_pressed("right_down"):
		right_paddle.position.y += paddle_speed * delta
	if Input.is_action_pressed("right_up"):
		right_paddle.position.y -= paddle_speed * delta
	right_paddle.position = right_paddle.position.clamp(Vector2.ZERO+paddle_size,screen_size-paddle_size)

func reset_ball() -> void:
	if ball:
		ball.body_entered.disconnect(_on_ball_hit_wall)
		ball.queue_free()
	ball = ball_scene.instantiate()
	ball.global_position = ball_start_position
	ball.linear_velocity = Vector2([1,-1].pick_random(),randf_range(-1,1)).normalized() * ball_speed
	ball.body_entered.connect(_on_ball_hit_wall)
	add_child(ball)
	
func _on_ball_hit_wall(body: Node) -> void:
	if body == right:
		left_score_count += 1
		left_score.text = str(left_score_count)
		reset_ball.call_deferred()
	elif body == left:
		right_score_count += 1
		right_score.text = str(right_score_count)
		reset_ball.call_deferred()

extends Node

@export var ball_scene: PackedScene

@onready var ball: RigidBody2D
@onready var score: Label = $Board/Score
@onready var lives: Label = $Board/Lives
@onready var paddle: CharacterBody2D = $Paddle
@onready var bottom: StaticBody2D = $Walls/Bottom


var ball_start_position: Vector2
var paddle_start_position: Vector2
var score_count: int = 0
var lives_count: int = 3

var ball_speed = 400
var paddle_speed = 200
var screen_size: Vector2
var paddle_size: Vector2

func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	paddle_size = $Paddle/CollisionShape2D.shape.extents
	paddle_start_position = Vector2(
		screen_size.x / 2,
		screen_size.y * .9
	)
	ball_start_position = Vector2(
		paddle_start_position.x,
		paddle_start_position.y - paddle_size.y
	)
	
	reset_ball()
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		paddle.position.x += paddle_speed * delta
	if Input.is_action_pressed("left"):
		paddle.position.x -= paddle_speed * delta
	paddle.position = paddle.position.clamp(paddle_size,screen_size-paddle_size)

func reset_ball() -> void:
	paddle.position = paddle_start_position
	if ball:
		ball.body_entered.disconnect(_on_ball_hit_wall)
		ball.queue_free()
	ball = ball_scene.instantiate()
	ball.global_position = ball_start_position
	ball.linear_velocity = Vector2.UP.normalized() * ball_speed
	ball.body_entered.connect(_on_ball_hit_wall)
	add_child(ball)
	
func _on_ball_hit_wall(body: Node) -> void:
	if body == bottom:
		lives_count -= 1
		lives.text = str(lives_count)
		reset_ball.call_deferred()
	if body == paddle:
		var offset = (ball.global_position.x - paddle.global_position.x) / paddle_size.x
		var direction = Vector2(offset, -1).normalized()
		ball.linear_velocity = direction * ball_speed

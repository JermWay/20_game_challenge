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
var speed = 400

func _ready() -> void:
	ball_start_position = get_viewport().get_visible_rect().size / 2
	reset_ball()
	
func reset_ball() -> void:
	if ball:
		ball.body_entered.disconnect(_on_ball_hit_wall)
		ball.queue_free()
	ball = ball_scene.instantiate()
	ball.global_position = ball_start_position
	ball.linear_velocity = Vector2(1, 1).normalized() * speed
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

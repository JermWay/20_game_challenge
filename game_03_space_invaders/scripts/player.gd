extends CharacterBody2D

@export var player_speed: float = 200
@export var rocket_scene: PackedScene
@export var explode_scene: PackedScene


@onready var extents = $CollisionShape2D.shape.extents
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var rocket: Area2D
var movement_limits: Rect2
var rocket_manager: Node2D

func _physics_process(delta: float) -> void:
	if not is_node_ready():
		return
	handle_input(delta)

func handle_input(delta: float) -> void:

	var move_direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		move_direction += Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("move_down"):
		move_direction += Vector2.DOWN
	if Input.is_action_pressed("move_up"):
		move_direction += Vector2.UP
		
	move_player(move_direction.normalized(), delta)
	
	if Input.is_action_just_pressed("ui_accept"):
		fire()

func move_player(move_direction: Vector2, delta: float) -> void:
	position += move_direction * delta * player_speed
	position = position.clamp(
		movement_limits.position + extents,
		movement_limits.position + movement_limits.size - extents
	)
	
	if move_direction != Vector2.ZERO:
		sprite_2d.play("default")
	else:
		sprite_2d.stop()

func fire() -> void:
	rocket = rocket_scene.instantiate()
	rocket.position = position
	rocket.position.y -= extents.y
	rocket_manager.add_child(rocket)


func _on_tree_exiting() -> void:
	var explode:CPUParticles2D = explode_scene.instantiate()
	explode.global_position = global_position
	get_tree().root.add_child(explode)

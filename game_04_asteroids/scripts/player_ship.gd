extends CharacterBody2D

@export var rotation_speed: float = 2.0
@export var speed: float = 150.0
@export var acceleration: float = 0.01

var is_accelerating: bool = false

@onready var thruster_sfx: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	global_position = get_viewport_rect().get_center()
func _process(_delta: float) -> void:
	if is_accelerating:
		if not thruster_sfx.playing:
			thruster_sfx.play()
	elif thruster_sfx.playing:
		thruster_sfx.stop()
		
func _physics_process(delta: float) -> void:
	var rotation_input: float = 0.0
	if Input.is_action_pressed("turn_left"):
		rotation_input -= 1.0
	if Input.is_action_pressed("turn_right"):
		rotation_input += 1.0
	rotate(rotation_input * rotation_speed * delta)
	var facing_direction: Vector2 = Vector2.UP.rotated(rotation)
		
	var target_velocity: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("thrust"):
		target_velocity = facing_direction * speed
	
	is_accelerating = target_velocity != Vector2.ZERO
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	
	move_and_slide()

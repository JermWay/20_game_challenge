extends CharacterBody2D

@export var rotation_speed: float = 2.0
@export var speed: float = 150.0
@export var acceleration: float = 0.01

var is_accelerating: bool = false
var is_rotating: bool = false

@onready var thruster_sfx: AudioStreamPlayer = $AudioStreamPlayer
@onready var thruster_particles_center: CPUParticles2D = $ThrusterParticles/Center
@onready var thruster_particles_left: CPUParticles2D = $ThrusterParticles/Left
@onready var thruster_particles_right: CPUParticles2D = $ThrusterParticles/Right

func _ready() -> void:
	global_position = get_viewport_rect().get_center()
	
func _process(_delta: float) -> void:
	if (is_accelerating or is_rotating) != thruster_sfx.playing:
		thruster_sfx.playing = is_accelerating or is_rotating
		
func _physics_process(delta: float) -> void:
	var rotation_input: float = 0.0
	if Input.is_action_pressed("turn_left"):
		rotation_input -= 1.0
	if Input.is_action_pressed("turn_right"):
		rotation_input += 1.0
	
	is_rotating = Input.is_action_pressed("turn_right") or Input.is_action_pressed("turn_left")
	thruster_particles_left.emitting = Input.is_action_pressed("turn_right")
	thruster_particles_right.emitting = Input.is_action_pressed("turn_left")
	
	rotate(rotation_input * rotation_speed * delta)
	var facing_direction: Vector2 = Vector2.UP.rotated(rotation)

	var target_velocity: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("thrust"):
		target_velocity = facing_direction * speed
	
	is_accelerating = target_velocity != Vector2.ZERO
	thruster_particles_center.emitting = is_accelerating
	
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	move_and_slide()

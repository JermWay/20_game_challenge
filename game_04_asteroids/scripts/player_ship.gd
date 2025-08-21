extends Area2D

@export var rotation_speed: float = 2.0
@export var max_speed: float = 150.0
@export var thrust_force: float = 200
@export var bullet_pool: Node

var is_thrusting: bool = false
var is_rotating: bool = false
var velocity: Vector2 = Vector2.ZERO

@onready var thruster_sfx: AudioStreamPlayer = $ThrusterSFX
@onready var fire_sfx: AudioStreamPlayer = $FireSFX
@onready var thruster_particles_center: CPUParticles2D = $ThrusterParticles/Center
@onready var thruster_particles_left: CPUParticles2D = $ThrusterParticles/Left
@onready var thruster_particles_right: CPUParticles2D = $ThrusterParticles/Right

func _ready() -> void:
	global_position = get_viewport_rect().get_center()
	
func _process(_delta: float) -> void:
	if (is_thrusting or is_rotating) != thruster_sfx.playing:
		thruster_sfx.playing = is_thrusting or is_rotating
		
func _physics_process(delta: float) -> void:
	handle_fire()
	handle_rotation(delta)
	handle_thrust(delta)
	
func handle_thrust(delta: float) -> void:
	var facing_direction: Vector2 = Vector2.UP.rotated(rotation)
	
	is_thrusting = Input.is_action_pressed("thrust")
	thruster_particles_center.emitting = is_thrusting
	
	if is_thrusting:
		velocity += facing_direction * thrust_force * delta
	
	var speed = velocity.length()
	if speed > max_speed:
		velocity = velocity.normalized() * max_speed
	position += velocity * delta
	
func handle_rotation(delta: float) -> void:
	var left = Input.is_action_pressed("turn_left")
	var right = Input.is_action_pressed("turn_right")
	var rotation_input: float = 0.0
	
	if left:
		rotation_input -= 1.0
	if right:
		rotation_input += 1.0
	
	is_rotating = right or left
	thruster_particles_left.emitting = right
	thruster_particles_right.emitting = left
	
	rotate(rotation_input * rotation_speed * delta)
	
func handle_fire() -> void:
	if Input.is_action_just_pressed("fire"):
		if fire_sfx.playing:
			fire_sfx.stop()
		fire_sfx.play()
		bullet_pool.fire(global_position, rotation)

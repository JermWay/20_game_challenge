extends Node

@export var asteroid_large_scene: PackedScene
@export var start_wave_count: int = 0

@onready var ui: Control = $"../../UI"
@onready var score: Label = $"../../UI/Score"

var is_reseting: bool = false

func _ready() -> void:
	spawn_wave()
	
func spawn_wave() -> void:
	var wave_count: = start_wave_count
	if ui.is_node_ready():
		wave_count += ui.waves.count
	for count in range(wave_count):
		var asteroid = asteroid_large_scene.instantiate()
		add_child(asteroid)
		asteroid.initialize_asteroid(asteroid.pick_random_position(), asteroid.pick_random_direction())
	
func reset() -> void:
	is_reseting = true
	for asteroid in get_children():
		asteroid.queue_free()
	spawn_wave()
	is_reseting = false
	
func _process(_delta: float) -> void:
	if not is_reseting and get_child_count() == 0:
		ui.waves.count += 1
		spawn_wave()

func _on_child_entered_tree(child: Node) -> void:
	if child is Asteroid:
		child.destroyed.connect(_on_asteroid_destroyed)
		
func _on_asteroid_destroyed(points: int):
	ui.score.count += points

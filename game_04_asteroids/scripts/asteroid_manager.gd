extends Node

@export var asteroid_large_scene: PackedScene
@export var start_wave_count: int = 4

func _ready() -> void:
	for count in range(start_wave_count):
		var asteroid = asteroid_large_scene.instantiate()
		add_child(asteroid)
		asteroid.initialize_asteroid(asteroid.pick_random_position(), asteroid.pick_random_direction())

func _process(_delta: float) -> void:
	if get_child_count() == 0:
		print("wave over")

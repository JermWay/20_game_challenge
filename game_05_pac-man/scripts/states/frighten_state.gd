extends GhostState

func get_target_global_position() -> Vector2:
	var random_tile = maze.walkables.keys().pick_random()
	return maze.tile_to_global(random_tile)

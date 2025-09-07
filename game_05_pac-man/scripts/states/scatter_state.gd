extends GhostState

@onready var scatter_target: Marker2D = $"../../../Marker2D"

func get_target_global_position() -> Vector2:
	return scatter_target.global_position

extends GhostState


@onready var pac_man: AnimatedSprite2D = $"../../../PacMan"

func get_target_global_position() -> Vector2:
	return pac_man.global_position

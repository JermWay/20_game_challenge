extends Node

@onready var game: Node2D = $Game
@onready var ui: Control = $UI

func _ready() -> void:
	game.pac_man.scored.connect(ui.score.add_points)

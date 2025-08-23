extends HBoxContainer

@export var life_texture: Texture2D
@export var start_lives: int = 3

@onready var ui: Control = $".."
@onready var game: Node = $"../../Game"

func reset() -> void:
	for count in range(start_lives):
		add_life()
		
func add_life() -> void:
	var life: TextureRect = TextureRect.new()
	life.texture = life_texture
	life.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	add_child(life)
	
func remove_life() -> void:
	var life_count = get_lives() - 1
	get_child(life_count).queue_free()
	if life_count < 1:
		game.free_ship()
		ui.game_over_panel.visible = true
		
func get_lives() -> int:
	return get_child_count()

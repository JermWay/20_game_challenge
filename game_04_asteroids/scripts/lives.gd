extends HBoxContainer

@export var life_texture: Texture2D
@export var start_lives: int = 3

func _ready() -> void:
	reset_ui()
	
func reset_ui() -> void:
	reset_lives()
	reset_score()
	reset_waves()
	
func reset_lives() -> void:
	for count in range(start_lives):
		add_life()
	
func reset_score() -> void:
	pass
	
func reset_waves() -> void:
	pass
	
func add_life() -> void:
	var life: TextureRect = TextureRect.new()
	life.texture = life_texture
	life.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	add_child(life)
	
func remove_life() -> void:
	var life_count = get_lives() - 1
	get_child(life_count).queue_free()
	if life_count < 1:
		reset_ui()
		
func get_lives() -> int:
	return get_child_count()

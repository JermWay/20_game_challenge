extends Control

@onready var score: Label = $Panel/Score
@onready var high_score: Label = $"Panel/HighScore"
@onready var lives: HBoxContainer = $Panel/Lives

var save_path = "user://score.save"

var score_count: int = 0:
		set(new_value):
			score_count = new_value
			score.text = str(score_count)
		get: 
			return score_count
			
var high_score_count: int = 0:
		set(new_value):
			high_score_count = new_value
			high_score.text = str(high_score_count)
		get: 
			return high_score_count

func _ready() -> void:
	load_score()
	score_count = 0
	
func on_alien_hit() -> void:
	score_count += 1

func remove_life() -> void:
	save_score()
	lives.get_child(0).queue_free()

func get_lives() -> int:
	return lives.get_child_count()
	
func save_score():
	if high_score_count < score_count:
		high_score_count = score_count
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(high_score_count)

func load_score():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		high_score_count = file.get_var()
	else:
		print("file not found")
		high_score_count = 0

extends Control

@onready var score: Label = $Panel/Score

var score_count: int = 0:
		set(new_value):
			score_count = new_value
			score.text = str(score_count)
		get: 
			return score_count
			
func on_alien_hit() -> void:
	score_count += 1

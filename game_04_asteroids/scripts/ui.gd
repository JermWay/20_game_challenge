extends Control

@onready var score: Label = $Score
@onready var waves: Label = $Waves
@onready var lives: HBoxContainer = $Lives


func _ready() -> void:
	reset_ui()
	
func reset_ui() -> void:
	lives.reset()
	score.reset()
	waves.reset()

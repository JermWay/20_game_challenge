extends CharacterBody2D

@export var speed: float = 200
@onready var animation: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	animation.play()
	
func _process(delta: float) -> void:
	position.y += delta * speed
	if position.y > 400:
		queue_free()

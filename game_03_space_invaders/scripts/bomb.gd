extends Area2D

@export var speed: float = 200

@onready var animation: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	animation.play()
	
func _process(delta: float) -> void:
	position.y += delta * speed
	if global_position.y > get_viewport().get_visible_rect().size.y:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.visible = false
		queue_free()

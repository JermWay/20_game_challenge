extends Area2D

@export var speed: float = 200

func _process(delta: float) -> void:
	position.y -= delta * speed
	if position.y < 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
	queue_free()

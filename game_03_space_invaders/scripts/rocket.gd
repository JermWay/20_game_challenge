extends Area2D

signal alien_hit

@export var speed: float = 200
@export var explode_scene: PackedScene

func _process(delta: float) -> void:
	position.y -= delta * speed
	if position.y < 50:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	var explode:CPUParticles2D = explode_scene.instantiate()
	explode.global_position = area.global_position
	get_tree().root.add_child(explode)
	if area.is_in_group("alien"):
		alien_hit.emit()
		area.queue_free()
	if area.is_in_group("bonus"):
		if not area.get_parent().is_active:
			return
		alien_hit.emit()
		area.visible = false
		area.get_parent().is_active = false
		area.get_parent().start()
	if area.is_in_group("bomb"):
		area.queue_free()
	queue_free()

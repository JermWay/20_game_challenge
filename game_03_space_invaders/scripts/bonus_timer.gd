extends Timer

@onready var bonus: Area2D = $Bonus
var is_active = false
@export var speed = 200
func _ready() -> void:
	bonus.visible = false
	
func _process(delta: float) -> void:
	if is_active:
		bonus.position.x += delta* speed
		if bonus.global_position.x > get_viewport().size.x:
			is_active = false
			bonus.visible = false
			self.start(randf()*3)
			
	if not is_active:
		bonus.global_position = Vector2(0, 50+16+10)
		
func _on_timeout() -> void:
	bonus.global_position = Vector2(0, 50+16+10)
	bonus.visible = true
	is_active = true
	

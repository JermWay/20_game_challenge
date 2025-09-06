extends Node

@export var initial_state: State

var previous_state: State
var current_state: State
var states: Dictionary[StringName, State] = {}

func _ready() -> void:
	for child: Node in get_children():
		var state := child as State
		states[state.name.to_lower()] = state
		state.transitioned.connect(_on_state_transitioned)
		
	if initial_state:
		initial_state.enter()
		current_state = initial_state
		
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
		
func _on_state_transitioned(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if new_state == null:
		return
		
	previous_state = current_state
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state

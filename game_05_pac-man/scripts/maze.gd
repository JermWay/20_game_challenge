extends TileMapLayer

const DEBUG: bool = true

var intersections: Dictionary = {}

@onready var width: int = get_used_rect().size.x

func _ready() -> void:
	log_intersections()
	
	if DEBUG:
		for cell in get_used_cells():
			if not is_walkable(cell):
				continue
			var coord_label = Label.new()
			coord_label.text = str(cell)
			coord_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			coord_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			coord_label.add_theme_font_size_override("font_size", 3)
			coord_label.position = map_to_local(cell)
			if intersections[cell]:
				coord_label.add_theme_color_override("font_color", Color.REBECCA_PURPLE)
			add_child(coord_label)
		
func find_path(start_cell: Vector2i, end_cell: Vector2i, prev_cell: Vector2i) -> Array[Vector2i]:
	var queue: Array[Vector2i] = []
	queue.push_back(start_cell)
	var came_from: Dictionary = {}
	came_from[start_cell] = null
	
	var end_found = false
	var visited: Array[Vector2i] = []
	if prev_cell != null:
		visited.append(prev_cell)
	
	while queue.size() > 0  and not end_found:
		var current_cell = queue.pop_front()
		var surronding_cells = get_surrounding_cells(current_cell)
		for cell in surronding_cells:
			if cell.x < 0:
				cell.x = width - 1
			if cell.x >= width:
				cell.x = 0
			if cell == end_cell:
				came_from[cell] = current_cell
				end_found = true
				break
			if is_walkable(cell) and not queue.has(cell) and not visited.has(cell):
				queue.push_back(cell)
				came_from[cell] = current_cell
		visited.push_back(current_cell)
		
	if not end_found:
		return []
		
	var path: Array[Vector2i] = []
	var current_path_cell = end_cell
	while current_path_cell != null:
		path.push_front(current_path_cell)
		current_path_cell = came_from[current_path_cell]
	return path
	
func log_intersections() -> void:
	for cell in get_used_cells():
		if not is_walkable(cell):
			continue
			
		intersections[cell] = false
		var neighbors = get_surrounding_cells(cell).filter(is_walkable)
		if neighbors.size() > 2:
			intersections[cell] = true
			
func is_walkable(cell: Vector2i):
	return get_cell_tile_data(cell) != null and get_cell_tile_data(cell).get_custom_data("is_walkable")
	
func is_intersection(cell: Vector2i) -> bool:
	return intersections.get(cell, false)
	
func global_to_tile(global_pos: Vector2) -> Vector2i:
	var local_pos = to_local(global_pos)
	return local_to_map(local_pos)
	
func tile_to_global(tile: Vector2i) -> Vector2:
	var local_pos = map_to_local(tile)
	return to_global(local_pos)

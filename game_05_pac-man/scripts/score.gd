extends Label

var count: int = 0:
		set(new_value):
			count = new_value
			text = "%05d" % count
		get: 
			return count
			
func reset():
	count = 0

func add_points(points: int):
	count += points

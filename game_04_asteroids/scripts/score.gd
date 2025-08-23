extends Label

var count: int = 0:
		set(new_value):
			count = new_value
			text = str(count)
		get: 
			return count
			
func reset():
	count = 0

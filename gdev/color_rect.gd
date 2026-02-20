extends Control

func _draw():
	# Draw a vertical line and a horizontal line (a "plus" sign)
	var center = size / 2
	var length = 10
	var thickness = 2
	var color = Color.WHITE
	
	# Horizontal line
	draw_line(Vector2(center.x - length, center.y), Vector2(center.x + length, center.y), color, thickness)
	# Vertical line
	draw_line(Vector2(center.x, center.y - length), Vector2(center.x, center.y + length), color, thickness)

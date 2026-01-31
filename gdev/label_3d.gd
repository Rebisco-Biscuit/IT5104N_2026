extends Label3D

func _process(delta):
	rotate_y(1.0 * delta)  # Rotates 1 radian per second around Y axis

extends StaticBody3D

var move_range = 2.0
var speed = 3.0
var direction = 1

func _process(delta):
	position.x += speed * direction * delta
	if abs(position.x) > move_range:
		direction *= -1

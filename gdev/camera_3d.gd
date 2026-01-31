extends Camera3D

@onready var confetti = get_parent().get_node("Confetti")
@onready var mesh = get_parent().get_node("MeshInstance3D")  # Adjust path if needed

var speed = 1.0  # radians per second

func _process(delta):
	# No camera orbit, keep camera still

	# Rotate the mesh around Y-axis
	if mesh:
		mesh.rotate_y(speed * delta)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = event.position
		var ray_origin = project_ray_origin(mouse_pos)
		var ray_dir = project_ray_normal(mouse_pos)

		var space = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(
			ray_origin,
			ray_origin + ray_dir * 1000
		)

		var result = space.intersect_ray(query)

		if result:
			confetti.global_position = result.position
			confetti.restart()

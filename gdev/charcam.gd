extends Camera3D

@export var mouse_sensitivity: float = 0.002
@onready var player = get_parent()

func _ready():
	# Capture the mouse so it doesn't leave the game window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Handle mouse movement for looking around
	if event is InputEventMouseMotion:
		# Rotate the player left/right (Y-axis)
		player.rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Rotate the camera up/down (X-axis)
		rotate_x(-event.relative.y * mouse_sensitivity)
		
		# Clamp vertical rotation so you can't flip your head upside down
		rotation.x = clamp(rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _process(_delta):
	# Keep the camera at the player's eye level
	# Adjust Vector3(0, 1.7, 0) to match your character's height
	global_position = player.global_position + Vector3(0, 1.7, 0)

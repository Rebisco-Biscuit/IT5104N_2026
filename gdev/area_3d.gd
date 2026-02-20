extends Area3D

# Drag obstacle2 from the scene tree into this slot
@export var target_destination: Node3D 
# How high above the obstacle center to spawn (e.g., 2.0 meters)
@export var spawn_height_offset: float = 2.0

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Using 'body is CharacterBody3D' is a reliable way to check for players
	if body is CharacterBody3D:
		if target_destination:
			teleport_player(body)

func teleport_player(player):
	# Calculate the new position: Destination + Y Offset
	var new_pos = target_destination.global_position
	new_pos.y += spawn_height_offset
	
	# Snap the player to the new position
	player.global_position = new_pos
	
	# Clear velocity so they don't go flying or sliding upon arrival
	player.velocity = Vector3.ZERO
	
	print("Teleported safely above ", target_destination.name)

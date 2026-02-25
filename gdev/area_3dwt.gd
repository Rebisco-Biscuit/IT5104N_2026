extends Area3D

func _on_body_entered(body):
	# ONLY trigger if the thing entering is the Player
	if body.is_in_group("Player") or body.name == "Player":
		print("Player hit a trap!")
		body.respawn() # Call the die function we will add to the player

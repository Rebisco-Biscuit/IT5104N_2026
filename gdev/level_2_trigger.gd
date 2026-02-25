extends Area3D

@onready var label = get_node("/root/Node3D/UI/NotifLabel")

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody3D:
		label.show()
		body.global_position = Vector3(-30, 2, 0)
		#body.speed += 5.0
		await get_tree().create_timer(3.0).timeout
		label.hide()

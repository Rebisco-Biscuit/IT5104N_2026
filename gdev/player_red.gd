extends CharacterBody2D

@export var speed = 200
@export var jump_force = -400
@export var gravity = 900

@export var left_action : String
@export var right_action : String
@export var jump_action : String

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		velocity.y = jump_force

	var dir = Input.get_axis(left_action, right_action)

	velocity.x = dir * speed

	move_and_slide()

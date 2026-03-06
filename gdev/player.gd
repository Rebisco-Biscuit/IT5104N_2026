extends CharacterBody3D

@export_group("Movement")
@export var speed: float = 6.0
@export var jump_velocity: float = 4.5
@export var gravity: float = 12.0
@export var dodge_speed: float = 15.0

@export_group("Health & Falling")
@export var max_health: float = 100.0
@export var fall_damage_threshold: float = 3.0
@export var damage_per_meter: float = 15.0
@export var kill_y_level: float = -15.0

# Internal Variables
var current_health: float = 100.0
var dodge_timer: float = 0.0
var spawn_point: Vector3
var highest_y: float = 0.0
var was_in_air: bool = false

# --- UI ---
@onready var health_bar = get_node("/root/Node3D/UI/healthbar")
@onready var score_label = get_node("/root/Node3D/UI/ScoreLabel")

# --- AUDIO ---
@onready var walk_sound = $WalkSound
@onready var jump_sound = $JumpSound
@onready var dodge_sound = $DodgeSound

# --- SCORE SYSTEM ---
var score: int = 0

func _ready():
	spawn_point = global_position
	current_health = max_health
	update_ui()

func _physics_process(delta):

	# SCORE increases while alive
	if velocity.length() > 0.5:
		score += 1
		update_score()

	# 1. FALL DAMAGE LOGIC
	if not is_on_floor():
		if not was_in_air:
			was_in_air = true
			highest_y = global_position.y
		else:
			highest_y = max(highest_y, global_position.y)
	else:
		if was_in_air:
			var fall_distance = highest_y - global_position.y
			if fall_distance > fall_damage_threshold:
				var damage = (fall_distance - fall_damage_threshold) * damage_per_meter
				take_damage(damage)
			was_in_air = false
			highest_y = global_position.y

	# 2. GRAVITY & RESPAWN
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if global_position.y < kill_y_level:
		respawn()

	# 3. JUMPING
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		if jump_sound:
			jump_sound.play()

	# 4. MOVEMENT
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# 5. DODGE MECHANIC
	if Input.is_action_just_pressed("dodge") and dodge_timer <= 0:
		dodge_timer = 0.2
		var dodge_dir = direction if direction != Vector3.ZERO else -transform.basis.z
		velocity.x = dodge_dir.x * dodge_speed
		velocity.z = dodge_dir.z * dodge_speed
		
		if dodge_sound:
			dodge_sound.play()

	# 6. APPLY VELOCITY
	if dodge_timer > 0:
		dodge_timer -= delta
	else:
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

	# WALK SOUND
	if is_on_floor() and velocity.length() > 1:
		if walk_sound and not walk_sound.playing:
			walk_sound.play()
	else:
		if walk_sound:
			walk_sound.stop()


# --- HELPER FUNCTIONS ---

func take_damage(amount: float):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	update_ui()
	print("Damage taken: ", amount, " | Remaining: ", current_health)
	
	if current_health <= 0:
		die()


func die():
	print("Player died.")
	respawn()


func update_ui():
	if health_bar:
		health_bar.value = current_health


func update_score():
	if score_label:
		score_label.text = "Score: " + str(score)


func respawn():
	global_position = spawn_point
	velocity = Vector3.ZERO
	current_health = max_health
	score = 0
	update_ui()
	update_score()
	print("Respawned!")


func respawn2():
	global_position = Vector3(-30, 2, 0)
	velocity = Vector3.ZERO
	current_health = max_health
	score = 0
	update_ui()
	update_score()
	print("Respawned!")

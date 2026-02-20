extends CharacterBody3D

@export_group("Movement")
@export var speed: float = 6.0
@export var jump_velocity: float = 4.5
@export var gravity: float = 12.0 # Slightly higher for "snappier" feel
@export var dodge_speed: float = 15.0

@export_group("Health & Falling")
@export var max_health: float = 100.0
@export var fall_damage_threshold: float = 3.0 # Fall more than 4m = damage
@export var damage_per_meter: float = 15.0     # Damage dealt per meter fallen
@export var kill_y_level: float = -15.0        # Respawn if below this

# Internal Variables
var current_health: float = 100.0
var dodge_timer: float = 0.0
var spawn_point: Vector3
var highest_y: float = 0.0
var was_in_air: bool = false

@onready var health_bar = get_node("/root/Node3D/UI/HealthBar") # Update this path!

func _ready():
	spawn_point = global_position
	current_health = max_health
	update_ui()

func _physics_process(delta):
	# 1. FALL DAMAGE LOGIC
	if not is_on_floor():
		if not was_in_air:
			# Just started falling/jumping
			was_in_air = true
			highest_y = global_position.y
		else:
			# Keep track of the peak height of the jump/fall
			highest_y = max(highest_y, global_position.y)
	else:
		if was_in_air:
			# We just landed! Calculate distance
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

	# 4. MOVEMENT (The "Rotation Fix")
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	# transform.basis converts the direction to face where the PLAYER faces
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# 5. DODGE MECHANIC
	if Input.is_action_just_pressed("dodge") and dodge_timer <= 0:
		dodge_timer = 0.2
		var dodge_dir = direction if direction != Vector3.ZERO else -transform.basis.z
		velocity.x = dodge_dir.x * dodge_speed
		velocity.z = dodge_dir.z * dodge_speed

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

# --- HELPER FUNCTIONS ---

func take_damage(amount: float):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	update_ui()
	print("Damage taken: ", amount, " | Remaining: ", current_health)
	
	if current_health <= 0:
		respawn()

func update_ui():
	if health_bar:
		health_bar.value = current_health

func respawn():
	global_position = spawn_point
	velocity = Vector3.ZERO
	current_health = max_health
	update_ui()
	print("Respawned!")

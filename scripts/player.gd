extends CharacterBody3D

var Current_speed
const runspeed_speed = 10.0
@export var jump_velocity = 10.0
@onready var camera = $head/Camera3D

const walk_speed = 5.0
@export var sens = 0.006;

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation.y = rotation.y - event.relative.x * sens
		camera.rotation.x = camera.rotation.x - event.relative.y * sens
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_pressed("sprint"):
		Current_speed = runspeed_speed
	else: 
		Current_speed = walk_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right","Up", "Down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * Current_speed
		velocity.z = direction.z * Current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, Current_speed)
		velocity.z = move_toward(velocity.z, 0, Current_speed)

	move_and_slide()

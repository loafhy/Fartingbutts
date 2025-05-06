extends CharacterBody3D

const walk_speed = 5.0
const runspeed_speed = 10.0
const bobamp= 0.08
const freq = 2.0
@export var jump_velocity = 8.95
@onready var camera = $CollisionShape3D/MeshInstance3D/head/Camera3D

var Current_speed
@export var sens = 0.006;

var tbob = 0.0

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
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * Current_speed
			velocity.z = direction.z * Current_speed
		else:
			velocity.x = lerp(velocity.x, direction.x *Current_speed, delta*7.3)
			velocity.z = lerp(velocity.z, direction.z *Current_speed, delta*7.3)
	else:
		velocity.x = lerp(velocity.x, direction.x *Current_speed, delta* 2.3)
		velocity.z = lerp(velocity.z, direction.z *Current_speed, delta * 2.3)
	tbob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(tbob)

	move_and_slide()
	
func _headbob(time) -> Vector3:
		var pos = Vector3.ZERO
		pos.y = sin(time*freq) * bobamp
		pos.x = cos(time*freq/ 2) * bobamp
		return pos

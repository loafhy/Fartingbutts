extends CharacterBody3D




@export var JUMP_VELOCITY = 4.5
@onready var camera = $head/Camera3D

const walk_speed = 5.0
const run_speed = 8.0

@export var sens = 0.006
var current_speed
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
		
	if Input.is_action_pressed("Sprint"):
		current_speed = run_speed
	else:
		current_speed = walk_speed

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()

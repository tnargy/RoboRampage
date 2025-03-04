extends CharacterBody3D


const SPEED = 5.0
const FALL_MULTIPLIER = 2.5
@export var jump_height: float = 1.0
@onready var camera_pivot = %CameraPivot
var mouse_motion := Vector2.ZERO


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	_handle_camera_rotation()
	
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >= 0:
			velocity += get_gravity() * delta
		else:
			velocity += get_gravity() * delta * FALL_MULTIPLIER

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _calculate_jump_velocity()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _input(event):	
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_motion = -event.relative * 0.001
			
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _handle_camera_rotation():
	var axis_vector = Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down")
	if axis_vector.length() >= 0.2:
		rotate_y(deg_to_rad(-axis_vector.x * 1.5))
		camera_pivot.rotate_x(deg_to_rad(-axis_vector.y * 1.5))
	else:
		rotate_y(mouse_motion.x)
		camera_pivot.rotate_x(mouse_motion.y)
		
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x, -90.0, 90.0
	)
	mouse_motion = Vector2.ZERO
	

func _calculate_jump_velocity() -> float:
	return sqrt(jump_height * FALL_MULTIPLIER * -get_gravity().y)

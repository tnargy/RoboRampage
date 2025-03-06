extends CharacterBody3D


const SPEED = 5.0
const AGGRO_RANGE := 12.0
@onready var navigation_agent_3d = %NavigationAgent3D
var player : CharacterBody3D
var provoked := false

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	if provoked:
		navigation_agent_3d.target_position = player.global_position

func _physics_process(delta):
	var next_pos = navigation_agent_3d.get_next_path_position()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction = global_position.direction_to(next_pos)
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= AGGRO_RANGE:
		provoked = true
		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if provoked:
		move_and_slide()

class_name Enemy
extends CharacterBody3D


const SPEED = 5.0
@export_range(0,5,0.5) var attack_range := 1.5
@export var aggro_range := 12.0
@export var max_health := 100
@export var damage := 15
@onready var navigation_agent_3d = %NavigationAgent3D
@onready var animation_player = %AnimationPlayer
var player : Player
var provoked := false
var hitpoints : int = max_health :
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			queue_free()
		provoked = true

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
	
	if distance <= aggro_range:
		provoked = true
		
	if provoked and distance <= attack_range:
		animation_player.play("Attack")
		
	if direction:
		look_at_target(direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if provoked:
		move_and_slide()


func look_at_target(direction: Vector3):
	var adj_direction = direction
	adj_direction.y = 0.0
	
	look_at(global_position + adj_direction, Vector3.UP, true)


func attack():
	player.hitpoints -= damage

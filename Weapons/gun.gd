class_name Gun
extends Node3D

@export_category("Gun Types")
@export var automatic := false
@export var sniper := false
@export_category("Gun Specs")
@export var weapon_damage := 15
@export var fire_rate := 14.0
@export var zoom_rate := 0.7
@export var recoil_x := 4
@export var recoil_z := 0.05
@export_category("Misc")
@export var spark_Scene : PackedScene
@export var weapon_mesh : MeshInstance3D
@export var ammo_handler : AmmoHandler
@export var ammo_type : AmmoHandler.AMMO_TYPE
@onready var cooldown = %Cooldown
@onready var muzzle_flash : GPUParticles3D = %MuzzleFlash
@onready var weapon_position : Vector3 = weapon_mesh.position
@onready var ray_cast_3d = $RayCast3D
var camera_pivot


func _ready():
	var player = get_tree().get_first_node_in_group("player")
	camera_pivot = player.find_child("CameraPivot")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cooldown.is_stopped():
		if (automatic and Input.is_action_pressed("fire")) \
			or Input.is_action_just_pressed("fire"):
			shoot()
		
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position, delta * 5)


func shoot():
	if not ammo_handler.has_ammo(ammo_type):
		return
	ammo_handler.use_ammo(ammo_type)
	muzzle_flash.restart()
	cooldown.start(1.0 / fire_rate)
	weapon_mesh.position.z -= recoil_z
	camera_pivot.rotation_degrees.x += recoil_x
	var collider = ray_cast_3d.get_collider()
	if collider is Enemy:
		collider.hitpoints -= weapon_damage
	var spark = spark_Scene.instantiate()
	add_child(spark)
	spark.global_position = ray_cast_3d.get_collision_point()

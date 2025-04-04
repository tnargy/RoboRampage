class_name WeaponHandler
extends Node3D

signal weapon_swapped

@export var weapons : Array[Gun]
@onready var smooth_camera: Camera3D = %SmoothCamera
@onready var weapon_camera: Camera3D = %WeaponCamera
var current_active : int
var player : Player


func _ready():
	equip(weapons[0])
	player = get_tree().get_first_node_in_group("player")


func _unhandled_input(event):
	if event.is_action_pressed("weapon_cycle_next"):
		var next_weapon = wrapi(current_active+1, 0, weapons.size())
		equip(weapons[next_weapon])
	elif event.is_action_pressed("weapon_cycle_prev"):
		var next_weapon = wrapi(current_active-1, 0, weapons.size())
		equip(weapons[next_weapon])
	elif event.is_action_pressed("aim"):
		_aim()
	elif event.is_action_released("aim"):
		_zoom_out()


func _aim():
	var gun = weapons[current_active]
	smooth_camera.fov *= gun.zoom_rate
	weapon_camera.fov *= gun.zoom_rate
	player.speed *= gun.zoom_rate
	gun.recoil_x /= 4
	if gun.sniper:
		find_child("Scope").visible = true


func _zoom_out():
	var gun = weapons[current_active]
	smooth_camera.fov /= gun.zoom_rate
	weapon_camera.fov /= gun.zoom_rate
	player.speed /= gun.zoom_rate
	gun.recoil_x *= 4
	if gun.sniper:
		find_child("Scope").visible = false


func equip(next_weapon : Gun):
	weapon_swapped.emit(next_weapon)
	var index = -1
	for child : Gun in get_children():
		index += 1
		if child == next_weapon:
			child.visible = true
			child.set_process(true)
			current_active = index
		else:
			child.visible = false
			child.set_process(false)

extends Node3D

@export var weapons : Array[Gun]
var current_active

func _ready():
	equip(weapons[0])


func _unhandled_input(event):
	if event.is_action_pressed("weapon_1"):
		equip(weapons[0])
	elif event.is_action_pressed("weapon_2"):
		equip(weapons[1])
	elif event.is_action_pressed("weapon_cycle_next"):
		var next_weapon = wrapi(current_active+1, 0, weapons.size())
		equip(weapons[next_weapon])
	elif event.is_action_pressed("weapon_cycle_prev"):
		var next_weapon = wrapi(current_active-1, 0, weapons.size())
		equip(weapons[next_weapon])


func equip(next_weapon : Gun):
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

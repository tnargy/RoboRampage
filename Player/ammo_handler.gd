class_name AmmoHandler
extends Node

signal ammo_used
enum AMMO_TYPE {
	BULLET,
	SMALL_BULLET
}

@export var ammo: Label
var ammo_storage := {
	AMMO_TYPE.BULLET: 10,
	AMMO_TYPE.SMALL_BULLET: 20
}


func _ready() -> void:
	ammo_used.connect(_update_ammo)


func _update_ammo(type: AMMO_TYPE):
	ammo.text = str(ammo_storage[type])


func has_ammo(type: AMMO_TYPE) -> bool:
	return ammo_storage[type] > 0


func use_ammo(type: AMMO_TYPE):
	if has_ammo(type):
		ammo_storage[type] -= 1
		ammo_used.emit(type)


func add_ammo(type: AMMO_TYPE, amount: int):
	ammo_storage[type] += amount
	ammo_used.emit(type)

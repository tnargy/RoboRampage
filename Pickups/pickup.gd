extends Area3D

@export var ammo_type : AmmoHandler.AMMO_TYPE
@export var amount := 20


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		queue_free()
		body.ammo_handler.add_ammo(ammo_type, amount)

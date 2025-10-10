extends "res://weapon.gd"

@export var fireball_instance: PackedScene

func use(direction: Vector2):
	var new = fireball_instance.instantiate()
	new.position = global_position
	new.direction = direction
	new.parent = get_parent().get_parent().get_parent()
	get_tree().root.add_child(new)

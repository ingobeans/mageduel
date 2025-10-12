extends Node2D

@export var use_delay = 1.0
@export var mana_cost = 20.0
var use_counter = 0.0

func use(_direction: Vector2):
	pass
	
func weapon_process(_delta:float):
	pass

func try_use(direction: Vector2)->bool:
	if use_counter <= 0.0:
		use_counter = use_delay
		use(direction)
		return true
	return false

func _process(delta: float) -> void:
	weapon_process(delta)
	use_counter -= delta

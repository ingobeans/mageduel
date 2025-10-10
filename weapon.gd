extends Node2D

@export var use_delay = 1.0
var use_counter = 0.0

func use(_direction: Vector2):
	pass

func try_use(direction: Vector2):
	if use_counter <= 0.0:
		use_counter = use_delay
		use(direction)

func _process(delta: float) -> void:
	use_counter -= delta

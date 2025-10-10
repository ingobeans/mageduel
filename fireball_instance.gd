extends AnimatedSprite2D

@export var explosion_particle: PackedScene

var direction: Vector2
var parent: Node2D
var speed = 100.0

func _process(delta: float) -> void:
	position += direction * delta * speed


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != parent:
		var explosion = explosion_particle.instantiate()
		explosion.position = global_position
		get_tree().root.add_child(explosion)
		queue_free()

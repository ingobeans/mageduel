extends Area2D

var parent: Node2D

var direction: Vector2

func _on_body_entered(body: Node2D) -> void:
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

extends AnimatedSprite2D

var knockback = 90 / 0.037
var damage = 20.0

var position_offset = Vector2(0.0,0.0)

var test: PackedScene = load("res://test.tscn")

var parent: Node2D
var hit = []

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !hit.has(body):
		hit.append(body)
	
		var delta = body.position - position + position_offset
		var dist = max(delta.length(),30.0)
		if body != parent:
			body.knockback(delta.normalized(), knockback / dist)
			body.add_damage(damage)
		else:
			body.knockback_friendly(delta.normalized(), knockback / dist)


func _on_animation_finished() -> void:
	queue_free()

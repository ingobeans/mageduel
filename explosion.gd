extends AnimatedSprite2D

var finished = false
var knockback = 1.12 / 0.037
var damage = 20.0

var position_offset = Vector2(0.0,0.0)

var test: PackedScene = load("res://test.tscn")

var hit = []

func _process(_delta: float) -> void:
	if frame >= sprite_frames.get_frame_count("default") - 1:
		finished = true
	if frame == 0 and finished:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !hit.has(body):
		hit.append(body)
	
		var delta = body.position - position + position_offset
		var dist = max(delta.length(),30.0)
		body.knockback(delta.normalized(), knockback / dist)
		body.add_damage(damage)

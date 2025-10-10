extends AnimatedSprite2D

var finished = false
var knockback = 9000.0

func _process(_delta: float) -> void:
	if frame >= sprite_frames.get_frame_count("default") - 1:
		finished = true
	if frame == 0 and finished:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var delta = body.position - position
	body.velocity += delta.normalized() / delta.length_squared() * knockback

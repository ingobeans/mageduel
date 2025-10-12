extends Sprite2D

var direction: Vector2
var parent: Node2D
var speed = 200.0
var knockback = 30
var damage = 6.0


func _ready() -> void:
	rotation = atan2(direction.y,direction.x)

func _process(delta: float) -> void:
	position += direction * delta * speed

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != parent:
		body.knockback(direction, knockback)
		body.add_damage(damage)
		queue_free()

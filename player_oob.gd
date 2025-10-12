extends Control

@export var player: Node2D
@onready var sprite = $PlayerOob

func _ready() -> void:
	$Sprite2D.texture = load("res://assets/player" + ("1" if player.player_one else "2") + "_portrait.png")

func _process(_delta: float) -> void:
	var p = player.global_position
	var viewport = get_viewport().get_visible_rect()
	var viewport_zoomed = viewport.size / get_viewport().get_camera_2d().zoom
	var camera_position = get_viewport().get_camera_2d().position
	var screen_center_dist = viewport_zoomed / 2 - Vector2(24.0,24.0)
	p.x = clamp(p.x,camera_position.x - screen_center_dist.x,camera_position.x+screen_center_dist.x)
	p.y = clamp(p.y,camera_position.y - screen_center_dist.y,camera_position.y+screen_center_dist.y)
	position = p
	var delta = player.position-camera_position
	sprite.rotation = atan2(delta.y,delta.x) + 3*PI / 4 + PI / 2 + PI
	visible = (p-camera_position).length() < (player.position-camera_position).length() - 16.0

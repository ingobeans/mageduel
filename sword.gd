extends "res://weapon.gd"

var knockback = 1.086
@onready var sprite = $Sprite
@onready var hit_area = $HitArea
@onready var deflect_area = $DeflectArea
@onready var player = get_parent().get_parent().get_parent()
@onready var player_flipped = get_parent().get_parent()

func weapon_process(delta:float):
	last_attack -= delta
	if waiting_to_hit and sprite.frame >= 3:
		can_hit = true
		waiting_to_hit = false
	if can_hit:
		var bodies = hit_area.get_overlapping_bodies()
		for body in bodies:
			if body != player:
				body.knockback(Vector2(-player_flipped.scale.x,0),knockback)
				body.add_damage(6.5)
				can_hit = false
		var areas = deflect_area.get_overlapping_areas()
		for a in areas:
			a.get_parent().direction.x = -player_flipped.scale.x
			a.get_parent().parent = player

var sequence_time = 1.0
var last_attack = 0.0
var can_hit = false
var waiting_to_hit = false

func use(_direction: Vector2):
	if last_attack > 0.0:
		last_attack = 0.0
		sprite.play("slashup")
	else:
		sprite.play("slashdown")
		last_attack = sequence_time
	waiting_to_hit = true

func _on_sprite_animation_finished() -> void:
	can_hit = false
	sprite.play("default")

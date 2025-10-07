extends CharacterBody2D

var speed = 650.0
var acceleration = 750.0
var friction = 3.0
var gravity = 600.0
var jump_force = 80.0
var max_jump_length = 0.25

var jump_counter = 0.0

var left_input = "wasd left"
var right_input = "wasd right"
var up_input = "wasd up"
var down_input = "wasd down"
var jump_input = "wasd jump"
var attack_input = "wasd attack"

func _process(delta: float) -> void:
	var on_ground = is_on_floor()
	if Input.is_action_pressed(jump_input):
		if on_ground:
			velocity.y = -jump_force * 1.25
			jump_counter = max_jump_length
		elif jump_counter > 0.0:
			velocity.y -= jump_force * delta * 17.0 * jump_counter / max_jump_length
			jump_counter -= delta
	else:
		jump_counter = 0.0

func _physics_process(delta: float) -> void:
	var on_ground = is_on_floor()
	var move_dir = Input.get_axis(left_input,right_input)
	var active_friction = friction
	
	velocity.y += gravity * delta
	
	if move_dir == 0 and on_ground:
		active_friction *= 4.0
	
	var can_move = true
	if velocity.x < -speed and move_dir < 0:
		can_move = false
	elif velocity.x > speed and move_dir > 0:
		can_move = false
	
	if can_move:
		velocity.x += move_dir * acceleration * delta
	
	velocity.x = lerp(velocity.x,0.0,active_friction*delta)
	move_and_slide()

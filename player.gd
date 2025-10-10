extends CharacterBody2D

var max_walk_speed = 100
var acceleration = 165.0 * 10
var friction = 3.0
var gravity = 600.0
var jump_force = 80.0
var max_jump_length = 0.25

@export var weapons: Array[PackedScene]

var jump_counter = 0.0

@export var player_one = false
var input_set = "player1"

var weapon: Node2D

func _ready() -> void:
	input_set = "player1" if player_one else "player2"
	if !player_one:
		$Flipped/Sprite.texture = load("res://assets/player2.png")
	else: 
		$Flipped.scale.x = -1
	
	var w = weapons[randi() % weapons.size()]
	$Flipped/Hand.add_child(w.instantiate())
	weapon = $Flipped/Hand.get_child(0)

func _process(delta: float) -> void:
	var on_ground = is_on_floor()
	if Input.is_action_pressed(input_set + " jump"):
		if on_ground:
			velocity.y = -jump_force * 1.25
			jump_counter = max_jump_length
		elif jump_counter > 0.0:
			velocity.y -= jump_force * delta * 17.0 * jump_counter / max_jump_length
			jump_counter -= delta
	else:
		jump_counter = 0.0
		
	if Input.is_action_just_pressed(input_set + " attack"):
		var direction = Vector2(Input.get_axis(input_set + " left",input_set + " right"), Input.get_axis(input_set + " up",input_set + " down"))
		if direction.length() == 0.0:
			direction = Vector2(-$Flipped.scale.x,0.0)
		weapon.try_use(direction)

func _physics_process(delta: float) -> void:
	var on_ground = is_on_floor()
	var move_dir = Input.get_axis(input_set + " left",input_set + " right")
	var active_friction = friction
	var max_speed = max_walk_speed
	
	velocity.y += gravity * delta
	
	if on_ground and (move_dir == 0 or (move_dir < 0 and velocity.x > 0) or (move_dir > 0 and velocity.x < 0)):
		active_friction *= 4.0
		move_dir *= 2.0
	if !on_ground:
		max_speed = 100
		active_friction = 0
	
	if move_dir > 0:
		$Flipped.scale.x = -1
	elif move_dir < 0:
		$Flipped.scale.x = 1
	
		
	if velocity.x - acceleration * delta < -max_speed and move_dir < 0:
		velocity.x = -max_speed
	elif velocity.x + acceleration * delta > max_speed and move_dir > 0:
		velocity.x = max_speed
	else:
		velocity.x += move_dir * acceleration * delta
	
	velocity.x = lerp(velocity.x,0.0,active_friction*delta)
	move_and_slide()

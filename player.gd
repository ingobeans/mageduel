extends CharacterBody2D

var max_walk_speed = 100
var acceleration = 165.0 * 2
var friction = 3.0
var gravity = 600.0
var jump_force = 80.0
var max_jump_length = 0.25
var shield_drain_speed = 25.0

var mana_charge_speed = 5.0

var damage = 0.0
var double_jump = 2

@export var player1_shield: Color
@export var player2_shield: Color

@export var weapons: Array[PackedScene]

var mana = 100.0
var jump_counter = 0.0
var mana_charge_delay = 1.0
var last_mana_use_counter = 0.0

@export var player_one = false
var input_set = "player1"

var weapon: Node2D

@onready var shield = $Flipped/Shield

func add_damage(amount:float):
	if shield.visible:
		return
	damage += amount
	
func knockback(direction:Vector2,strength:float):
	if shield.visible:
		return
	var dmg = max(10.0,damage)
	var s = (0.1 * pow(strength,dmg) + 5*strength*dmg)
	velocity += direction * s

func knockback_friendly(direction:Vector2,strength:float):
	if shield.visible:
		return
	var dmg = 40.0
	var s = (0.1 * pow(strength,dmg) + 5*strength*dmg)
	velocity += direction * s

func _ready() -> void:
	input_set = "player1" if player_one else "player2"
	if player_one:
		$Flipped.scale.x = -1
		shield.set_instance_shader_parameter("shield_color",player1_shield)
	else: 
		$Flipped/Sprite.texture = load("res://assets/player2.png")
		shield.set_instance_shader_parameter("shield_color",player2_shield)
	
	var w = weapons[randi() % weapons.size()]
	$Flipped/Hand.add_child(w.instantiate())
	weapon = $Flipped/Hand.get_child(0)

func _process(delta: float) -> void:
	var on_ground = is_on_floor()
	var dir = Input.get_axis(input_set + " left",input_set + " right")
	if Input.is_action_pressed(input_set + " down") and dir == 0.0 and on_ground and mana > 0.0:
		shield.visible = true
		mana -= delta * shield_drain_speed
		last_mana_use_counter = mana_charge_delay
	else:
		shield.visible = false
	
	mana += delta * mana_charge_speed * (7.0 if last_mana_use_counter <= 0.0 else 1.0)
	
	if Input.is_action_pressed(input_set + " jump"):
		if on_ground:
			velocity.y = -jump_force * 1.25
			jump_counter = max_jump_length
		elif jump_counter > 0.0:
			velocity.y -= jump_force * delta * 17.0 * jump_counter / max_jump_length
			jump_counter -= delta
	else:
		jump_counter = 0.0
	if Input.is_action_just_pressed(input_set + " jump") and !on_ground and jump_counter == 0.0 and double_jump > 0:
		double_jump -= 1
		if dir == 0.0:
			velocity.y = -jump_force * 2.95
			velocity.x = lerp(velocity.x,0.0,0.6)
		else:
			velocity.y = -jump_force * 2.65
			velocity.x = dir * jump_force * 1.5
			
		
	if on_ground:
		double_jump = 2
		
		
	if Input.is_action_just_pressed(input_set + " attack") and mana >= weapon.mana_cost:
		var direction = Vector2(dir, Input.get_axis(input_set + " up",input_set + " down"))
		if direction.length() == 0.0:
			direction = Vector2(-$Flipped.scale.x,0.0)
		if weapon.try_use(direction):
			mana -= weapon.mana_cost
			last_mana_use_counter = mana_charge_delay
	
	last_mana_use_counter -= delta
	mana = clamp(mana,0.0,100.0)

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
		pass
		#velocity.x = -max_speed
	elif velocity.x + acceleration * delta > max_speed and move_dir > 0:
		pass
		#velocity.x = max_speed
	else:
		velocity.x += move_dir * acceleration * delta
	
	velocity.x = lerp(velocity.x,0.0,active_friction*delta)
	move_and_slide()

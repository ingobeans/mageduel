extends Control

@export var player: Node2D
@export var player1_portrait: Texture2D
@export var player2_portrait: Texture2D

@export var names: Array[String]

@onready var mana_bar = $ManaFilled
var max_mana_width: float

func gen_name()->String:
	return names[randi() % names.size()]

func _ready() -> void:
	max_mana_width = mana_bar.size.x
	$Label.text = gen_name()
	if player.player_one:
		$Portrait.texture = player1_portrait
	else:
		$Portrait.texture = player2_portrait
	
func _process(_delta: float) -> void:
	mana_bar.size.x = player.mana / 100.0 * max_mana_width

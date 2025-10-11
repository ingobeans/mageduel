extends Control

@export var player: Node2D
@export var player1_portrait: Texture2D
@export var player2_portrait: Texture2D

@export var names: Array[String]
@export var titles: Array[String]

@onready var mana_bar = $ManaFilled
var max_mana_width: float

func gen_name()->String:
	var n = names[randi() % names.size()]
	if randf() < 0.5:
		var t = titles[randi() % titles.size()]
		n += " " + t
	return n

func _ready() -> void:
	max_mana_width = mana_bar.size.x
	var n = gen_name()
	$Label.text = n
	$Label.add_theme_font_size_override("font_size",min(256.0 / n.length() * 10.0,256.0))
	if player.player_one:
		$Portrait.texture = player1_portrait
	else:
		$Portrait.texture = player2_portrait
	
func _process(_delta: float) -> void:
	mana_bar.size.x = player.mana / 100.0 * max_mana_width

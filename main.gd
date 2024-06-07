extends Node2D


var current_map = 0
var background = [
	"res://map-1.png"
]

var p1_spawns = [
	Vector2(300, 540)
]
var p2_spawns = [
	Vector2(1620, 540)
]


func _ready():
	$Background.texture = load(background[current_map])


func _process(delta):
	pass

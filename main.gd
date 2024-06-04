extends Node2D


var current_map = 0
var background = [
	"res://map-1.png"
]


func _ready():
	$Background.texture = load(background[current_map])


func _process(delta):
	pass

extends Node2D


var current_map = -1
var backgrounds = [
	"res://bg-1.png"
]
var maps = [
	"res://map_1.tscn"
]

var p1_spawns = [
	Vector2(300, 540)
]
var p2_spawns = [
	Vector2(1620, 540)
]


func _ready():
	_map_switch()


func _map_switch():
	current_map += 1
	var new_map = load(maps[current_map]).instantiate()
	new_map.position = Vector2(1920, 0)
	add_child(new_map)
	while new_map.position.x > 0:
		new_map.position.x -= 32


func _process(delta):
	if Input.is_action_just_pressed("temp_map_switch"):
		_map_switch()

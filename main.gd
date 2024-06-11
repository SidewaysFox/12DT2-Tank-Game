extends Node2D


var next_map = 0
var current_map = null
var maps = [
	"res://map_1.tscn",
	"res://map_2.tscn",
]

var p1_spawns = [
	Vector2(300, 540),
	Vector2(150, 540),
]
var p2_spawns = [
	Vector2(1620, 540),
	Vector2(1770, 540),
]


func _ready():
	_map_switch(1)


func _map_switch(delta):
	# Check if the map cycle needs to loop
	if next_map == len(maps):
		next_map = 0
	# Create new map
	var new_map = load(maps[next_map]).instantiate()
	new_map.position = $CurrentMap.position
	$CurrentMap.add_child(new_map)
	# Map transition
	while new_map.global_position.x > 0:
		new_map.global_position.x -= 32 * delta
		print(new_map.global_position)
		if current_map != null:
			current_map.global_position.x -= 32 * delta
	# Delete previous map and set the new current map
	next_map += 1
	if current_map != null:
		current_map.queue_free()
	current_map = new_map


func _process(delta):
	if Input.is_action_just_pressed("temp_map_switch"):
		_map_switch(delta)

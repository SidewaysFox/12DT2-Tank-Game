extends Node2D


var next_map = 0
var new_map
var current_map
var switching = false
var switch_start = true
var show_map_name = false

var maps = [
	"res://map_1.tscn",
	"res://map_2.tscn",
	"res://map_3.tscn",
]

var map_names = [
	"Grasswall",
	"Grassierwall",
	"Grassiestwall"
]

var p1_spawns = [
	Vector2(300, 540),
	Vector2(150, 540),
	Vector2(200, 540),
]
var p2_spawns = [
	Vector2(1620, 540),
	Vector2(1770, 540),
	Vector2(1720, 540),
]


func _ready():
	_map_switch(1, true)
	new_map.global_position.x = 0
	next_map += 1
	current_map = new_map


func _map_switch(delta, initial: bool):
	if switch_start == true:
		# Check if the map cycle needs to loop
		if next_map == len(maps):
			next_map = 0
		# Create new map and position it in hierarchy
		new_map = load(maps[next_map]).instantiate()
		show_map_name = true
		new_map.global_position.x = 1920
		add_child(new_map)
		move_child(new_map, 0)
		switch_start = false
	
	# Map transition
	if not initial:
		if new_map.global_position.x > 0:
			new_map.global_position.x -= 3000 * delta
			current_map.global_position.x -= 3000 * delta
	
		# End of transition
		elif new_map.global_position.x <= 0:
			new_map.global_position.x = 0
			# Delete previous map and set the new current map
			show_map_name = false
			next_map += 1
			current_map.queue_free()
			current_map = new_map
			switching = false


func _process(delta):
	if Input.is_action_just_pressed("temp_map_switch") and switching == false:
		switching = true
		switch_start = true
		
	if switching:
		_map_switch(delta, false)
	
	if show_map_name:
		$CanvasLayer/ColorRect.show()
		$CanvasLayer/ColorRect/MapName.text = map_names[next_map]
	else:
		$CanvasLayer/ColorRect.hide()

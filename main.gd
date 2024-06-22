extends Node2D


var next_map = 0
var new_map
var current_map
var switching = false
var switch_start = true
var show_map_name = false

var maps = [
	["res://map_1.tscn", "Grasswall", Vector2(1, 1)],
	["res://map_2.tscn", "Grassierwall", Vector2(1, 1)],
	["res://map_3.tscn", "Grassiestwall", Vector2(1, 1)],
	["res://map_4.tscn", "Grasswall Duel", Vector2(2, 2)],
]

var p1_spawns = [
	Vector2(300, 540),
	Vector2(150, 540),
	Vector2(200, 540),
	Vector2(580, 540),
]
var p2_spawns = [
	Vector2(1620, 540),
	Vector2(1770, 540),
	Vector2(1720, 540),
	Vector2(1340, 540),
]


func _ready():
	_map_switch(1, true)
	new_map.global_position.x = 0
	next_map += 1
	current_map = new_map
	show_map_name = false


func _map_switch(delta, initial: bool):
	if switch_start == true:
		# Check if the map cycle needs to loop
		if next_map == len(maps):
			next_map = 0
		# Create new map and position it in hierarchy
		new_map = load(maps[next_map][0]).instantiate()
		show_map_name = true
		new_map.global_position.x = 1920
		add_child(new_map)
		move_child(new_map, 0)
		switch_start = false
	
	# Map transition
	if not initial:
		if new_map.global_position.x > 1:
			new_map.global_position = lerp(new_map.global_position, Vector2(0, 0), 0.1)
			current_map.global_position = lerp(current_map.global_position, Vector2(-1920, 0), 0.1)
			$Camera2D.zoom = lerp($Camera2D.zoom, maps[next_map][2], 0.1)
		
		# End of transition
		elif new_map.global_position.x <= 1:
			new_map.global_position.x = 0
			$Camera2D.zoom = maps[next_map][2]
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
		$CanvasLayer/MapRect.show()
		$CanvasLayer/MapRect/MapName.text = maps[next_map][1]
	else:
		$CanvasLayer/MapRect.hide()

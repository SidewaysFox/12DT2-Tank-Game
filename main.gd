extends Node2D


@onready var global = get_node("/root/Global")
var next_map = 0
var new_map
var current_map
var switching = false
var switch_start = true
var show_map_name = false
var p1_hp = 100
var p2_hp = 100
var max_ammo
var ammo1
var ammo2
var reload
var reloading1 = false
var reloading2 = false

signal up_score(winner)

var maps = [
	["res://maps/map_8.tscn", "Simulation", Vector2(1, 1)],
	["res://maps/map_6.tscn", "Empty", Vector2(1, 1)],
	["res://maps/map_7.tscn", "Centre", Vector2(1, 1)],
	["res://maps/map_5.tscn", "Square", Vector2(2, 2)],
	["res://maps/map_9.tscn", "Choke Point", Vector2(1.5, 1.5)],
	["res://maps/map_1.tscn", "Grasswall", Vector2(1, 1)],
	["res://maps/map_2.tscn", "Grassierwall", Vector2(1, 1)],
	["res://maps/map_3.tscn", "Grassiestwall", Vector2(1, 1)],
	["res://maps/map_4.tscn", "Grasswall Duel", Vector2(2, 2)],
]

var p1_spawns = [
	Vector2(300, 540), #8
	Vector2(200, 200), #6
	Vector2(300, 540), #7
	Vector2(580, 540), #5
	Vector2(400, 540), #9
	Vector2(300, 540), #1
	Vector2(150, 540), #2
	Vector2(200, 540), #3
	Vector2(580, 540), #4
]
var p2_spawns = [
	Vector2(1620, 540), #8
	Vector2(1720, 880), #6
	Vector2(1620, 540), #7
	Vector2(1340, 540), #5
	Vector2(1520, 540), #9
	Vector2(1620, 540), #1
	Vector2(1770, 540), #2
	Vector2(1720, 540), #3
	Vector2(1340, 540), #4
]


func _ready():
	# Set everything up
	_map_switch(1, true)
	new_map.global_position.x = 0
	next_map += 1
	current_map = new_map
	show_map_name = false
	if global.timer_on:
		$MatchTimer.start(global.timer_time)
	else:
		$CanvasLayer/TimerLabel.hide()
	max_ammo = global.max_ammo
	ammo1 = global.max_ammo
	ammo2 = global.max_ammo
	reload = global.reload
	$Music.play(global.music_progress)


func _map_switch(_delta, initial: bool):
	print("--------")
	print(new_map)
	print(current_map)
	# Is this the first frame of switching?
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
			# Delete previous map and set up the new current map
			show_map_name = false
			next_map += 1
			current_map.queue_free()
			current_map = new_map
			p1_hp = 100
			p2_hp = 100
			ammo1 = global.max_ammo
			ammo2 = global.max_ammo
			if global.timer_on:
				$MatchTimer.start(global.timer_time)
			$CanvasLayer/TimerLabel.add_theme_color_override("font_color", Color(0.78, 0.78, 0.78))
			switching = false
	print(new_map)
	print(current_map)
	print("--------")


func _process(delta):
	if not switching:
		# Should the map be switched?
		if not switch_start:
			$CanvasLayer/TimerLabel.text = str(snapped($MatchTimer.time_left, 0.1))
			# Who died
			if p1_hp <= 0:
				switch_start = true
				$SwitchWait.start(2.5)
				emit_signal("up_score", 2)
			if p2_hp <= 0:
				switch_start = true
				$SwitchWait.start(2.5)
				emit_signal("up_score", 1)
	else:
		_map_switch(delta, false)
	
	# Showing map name
	if show_map_name:
		$CanvasLayer/NameRect.show()
		$CanvasLayer/NameRect/MapName.text = maps[next_map][1]
	else:
		$CanvasLayer/NameRect.hide()


func _on_switch_wait_timeout():
	switching = true


func _out_of_time():
	switch_start = true
	$CanvasLayer/TimerLabel.add_theme_color_override("font_color", Color(1, 0.2, 0.2))
	$SwitchWait.start(1)

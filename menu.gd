extends Node2D


@onready var global = get_node("/root/Global")
var selected_menu = 0
var new_menu
var current_menu
var pushed = false
var switching = false
var switch_start = true
var p1_hp = 100
var p2_hp = 100
var play_hp = 3
var settings_hp = 3
var credits_hp = 3
var quit_hp = 3
var back_hp = 3
var push_hint = true

var menus = [
	["res://title_screen.tscn", Vector2(1, 1)],
	["res://settings_screen.tscn", Vector2(1, 1)],
	["res://credits_screen.tscn", Vector2(2, 2)],
	["res://loading_screen.tscn", Vector2(1, 1)]
]

var p1_spawns = [
	Vector2(300, 540),
	Vector2(300, 540),
	Vector2(540, 540),
	Vector2(300, 540),
]
var p2_spawns = [
	Vector2(1620, 540),
	Vector2(1620, 540),
	Vector2(1380, 540),
	Vector2(1620, 540),
]


func _ready():
	_menu_switch(1, 0, true)
	new_menu.global_position.x = 0
	selected_menu += 1
	current_menu = new_menu


func _menu_switch(_delta, location, initial: bool):
	if switch_start == true:
		play_hp = 3
		settings_hp = 3
		credits_hp = 3
		quit_hp = 3
		back_hp = 3
		# Create new menu and position it in hierarchy
		new_menu = load(menus[location][0]).instantiate()
		new_menu.global_position.x = 1920
		add_child(new_menu)
		move_child(new_menu, 0)
		switch_start = false
	
	# Menu transition
	if not initial:
		if new_menu.global_position.x > 1:
			new_menu.global_position = lerp(new_menu.global_position, Vector2(0, 0), 0.1)
			current_menu.global_position = lerp(current_menu.global_position, Vector2(-1920, 0), 0.1)
			$Camera2D.zoom = lerp($Camera2D.zoom, menus[location][1], 0.1)
		
		# End of transition
		elif new_menu.global_position.x <= 1:
			new_menu.global_position.x = 0
			$Camera2D.zoom = menus[selected_menu][1]
			# Delete previous menu and set the new current menu
			current_menu.queue_free()
			current_menu = new_menu
			p1_hp = 100
			p2_hp = 100
			switching = false
			if location == 3:
				$PlayTimer.start(1)
				# Look it doesn't feel authentic if I don't do this


func _process(delta):
	if not switching:
		# Should the menu be switched?
		if not switch_start:
			# What was pressed
			if settings_hp <= 0:
				switch_start = true
				switching = true
				selected_menu = 1
				push_hint = false
			elif credits_hp <= 0:
				switch_start = true
				switching = true
				selected_menu = 2
				push_hint = false
			elif play_hp <= 0:
				switch_start = true
				switching = true
				selected_menu = 3
				push_hint = false
			elif back_hp <= 0:
				switch_start = true
				switching = true
				selected_menu = 0
				push_hint = false
		
		if quit_hp <= 0:
			get_tree().quit()
	else:
		_menu_switch(delta, selected_menu, false)


func _on_play_timer_timeout():
	global.music_progress = $Music.get_playback_position() \
	+ AudioServer.get_time_since_last_mix()
	get_tree().change_scene_to_file("res://main.tscn")

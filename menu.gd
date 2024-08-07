extends Node2D


var selected_menu = 0
var new_menu
var current_menu
var pushed = false
var switching = false
var switch_start = true
var p1_hp = 100
var p2_hp = 100

var menus = [
	["res://title_screen.tscn", Vector2(1, 1)],
	["res://settings_screen.tscn", Vector2(1, 1)],
	["res://credits_screen.tscn", Vector2(2, 2)],
]

var p1_spawns = [
	Vector2(300, 540),
	Vector2(300, 540),
	Vector2(600, 540),
]
var p2_spawns = [
	Vector2(1620, 540),
	Vector2(1620, 540),
	Vector2(1320, 540),
]


func _ready():
	_menu_switch(1, 0, true)
	new_menu.global_position.x = 0
	selected_menu += 1
	current_menu = new_menu


func _menu_switch(delta, location, initial: bool):
	if switch_start == true:
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
			selected_menu += 1
			current_menu.queue_free()
			current_menu = new_menu
			p1_hp = 100
			p2_hp = 100
			switching = false


func _process(delta):
	if not switching:
		# Should the menu be switched?
		if not switch_start:
			# Who died
			if pushed:
				switch_start = true
				switching = true
	else:
		_menu_switch(delta, selected_menu, false)

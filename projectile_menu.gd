extends CharacterBody2D


@onready var menu = get_node("/root/Menu/")
@onready var global = get_node("/root/Global/")
@export var damage = 20
@export var projectile_speed = 100000
@export var particles: PackedScene
var direction: Vector2
var origin: int


func _ready():
	direction = Vector2(1, 0).rotated(rotation)


func _process(delta):
	# Go forth, my sweet rectangles
	velocity = direction * projectile_speed * delta
	move_and_slide()


func _on_area_2d_area_entered(area):
	# Collision with another projectile
	if area.has_meta("projectile"):
		queue_free()


func _on_area_2d_body_entered(body):
	# What did it just collide with (once again, please forgive me)
	if not body.has_meta("projectile"):
		if body.has_meta("p1"):
			# Reduce P1 HP
			menu.p1_hp -= damage
		if body.has_meta("p2"):
			# Reduce P2 HP
			menu.p2_hp -= damage
		if body.has_meta("play"): # Play button
			menu.play_hp -= 1
		if body.has_meta("settings"): # Settings button
			menu.settings_hp -= 1
		if body.has_meta("credits"): # Credits button
			menu.credits_hp -= 1
		if body.has_meta("quit"): # Quit button
			menu.quit_hp -= 1
		if body.has_meta("back"): # Back button
			menu.back_hp -= 1
		if body.has_meta("volume_up"): # Vol up button
			if global.volume < 91:
				global.volume += 10
		if body.has_meta("volume_down"): # Vol down button
			if global.volume > 9:
				global.volume -= 10
		if body.has_meta("timer"): # Timer on/off button
			if global.timer_on:
				global.timer_on = false
			else:
				global.timer_on = true
		if body.has_meta("time_up"): # Time up button
			if global.timer_time < 996:
				global.timer_time += 5
		if body.has_meta("time_down"): # Time down button
			if global.timer_time > 9:
				global.timer_time -= 5
		if body.has_meta("ammo_up"): # Ammo up button
			if global.max_ammo < 999:
				global.max_ammo += 1
		if body.has_meta("ammo_down"): # Ammo down button
			if global.max_ammo > 0:
				global.max_ammo -= 1
		if body.has_meta("colour") and origin == 1:
			if global.p1_colour < 7:
				global.p1_colour += 1
			else:
				global.p1_colour = 1
		if body.has_meta("colour") and origin == 2: # Colour button
			if global.p2_colour < 7:
				global.p2_colour += 1
			else:
				global.p2_colour = 1
		# Spawn particles and delete
		var new = particles.instantiate()
		new.global_rotation = global_rotation
		new.global_position = global_position
		add_sibling(new)
		queue_free()

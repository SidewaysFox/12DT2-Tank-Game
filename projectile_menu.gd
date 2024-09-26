extends CharacterBody2D


@onready var menu = get_node("/root/Menu/")
@onready var global = get_node("/root/Global/")
@export var projectile_speed = 100000
@export var particles: PackedScene
var direction: Vector2
var origin: int


func _ready():
	direction = Vector2(1, 0).rotated(rotation)


func _process(delta):
	velocity = direction * projectile_speed * delta
	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.has_meta("projectile"):
		queue_free()


func _on_area_2d_body_entered(body):
	if not body.has_meta("projectile"):
		if body.has_meta("p1"):
			menu.p1_hp -= randi_range(15, 20)
		if body.has_meta("p2"):
			menu.p2_hp -= randi_range(15, 20)
		if body.has_meta("play"):
			menu.play_hp -= 1
		if body.has_meta("settings"):
			menu.settings_hp -= 1
		if body.has_meta("credits"):
			menu.credits_hp -= 1
		if body.has_meta("quit"):
			menu.quit_hp -= 1
		if body.has_meta("back"):
			menu.back_hp -= 1
		if body.has_meta("volume_up"):
			if global.volume < 91:
				global.volume += 10
		if body.has_meta("volume_down"):
			if global.volume > 9:
				global.volume -= 10
		if body.has_meta("timer"):
			if global.timer_on:
				global.timer_on = false
			else:
				global.timer_on = true
		if body.has_meta("time_up"):
			if global.timer_time < 996:
				global.timer_time += 5
		if body.has_meta("time_down"):
			if global.timer_time > 9:
				global.timer_time -= 5
		if body.has_meta("ammo_up"):
			if global.max_ammo < 999:
				global.max_ammo += 1
		if body.has_meta("ammo_down"):
			if global.max_ammo > 0:
				global.max_ammo -= 1
		if body.has_meta("colour") and origin == 1:
			if global.p1_colour < 7:
				global.p1_colour += 1
			else:
				global.p1_colour = 1
		if body.has_meta("colour") and origin == 2:
			if global.p2_colour < 7:
				global.p2_colour += 1
			else:
				global.p2_colour = 1
		var new = particles.instantiate()
		new.global_rotation = global_rotation
		new.global_position = global_position
		add_sibling(new)
		queue_free()

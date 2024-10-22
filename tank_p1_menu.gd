extends MenuTankProcess


var hp1_check = 100
var respawning = false
var direction_inputted = false
var rotation_inputted = false
var fire_inputted = false
var explosion1 = false


func _ready():
	# Go to the right place
	position = menu.p1_spawns[menu.selected_menu]


func _process(delta):
	# Run the tank process class function
	# This handles input
	_tank_process(delta, 1, "p1_up", "p1_down", "p1_left", "p1_right",
			"p1_rotate_left", "p1_rotate_right", "p1_fire")
	
	# Set the right colour
	$Hull.texture = load("res://p" + str(global.p1_colour) + "-tank-hull.png")
	$Turret.texture = load("res://p" + str(global.p1_colour)
			+ "-tank-turret.png")
	$HealthBar.modulate = colours[global.p1_colour - 1]
	
	# The following stuff manages the "tutorial" UI
	# Have any of the directional inputs been made?
	if (
			Input.is_action_just_pressed("p1_up")
			or Input.is_action_just_pressed("p1_down")
			or Input.is_action_just_pressed("p1_left")
			or Input.is_action_just_pressed("p1_right")
	):
		direction_inputted = true
	
	# Have either of the rotational inputs been made?
	if (
			Input.is_action_just_pressed("p1_rotate_left")
			or Input.is_action_just_pressed("p1_rotate_right")
	):
		rotation_inputted = true
	
	# Has the fire input been made?
	if Input.is_action_just_pressed("p1_fire"):
		fire_inputted = true
	
	# Is the P1 tank respawning?
	if not respawning:
		# Is the menu currently switching?
		if not menu.switching:
			$CollisionShape2D.disabled = false
			$Area2D/CollisionShape2D.disabled = false
			# Has P1 died?
			if menu.p1_hp <= 0:
				hide()
				respawning = true
				$Respawn.start(3)
				# Has the explosion started yet?
				# In other words, is this the first frame of death?
				if not explosion1:
					var new_particles = death_particles.instantiate()
					new_particles.global_position = global_position
					add_sibling(new_particles)
					explosion1 = true
					$Explosion.play()
			else:
				show()
				explosion1 = false
		else:
			$CollisionShape2D.disabled = true
			$Area2D/CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = true
		$Area2D/CollisionShape2D.disabled = true
	
	# Has taken damage?
	if hp1_check != menu.p1_hp:
		$Hull.self_modulate = Color(1, 0.5, 0.5)
		$DamageEffect.start(0.1)
	
	$HealthBar.value = menu.p1_hp
	hp1_check = menu.p1_hp


# Reset colour
func _on_damage_effect_timeout():
	$Hull.self_modulate = Color(1, 1, 1)


# Respawn finished
func _on_respawn_timeout():
	position = menu.p1_spawns[menu.selected_menu]
	menu.p1_hp = 100
	show()
	$CollisionShape2D.disabled = false
	$Area2D/CollisionShape2D.disabled = false
	respawning = false

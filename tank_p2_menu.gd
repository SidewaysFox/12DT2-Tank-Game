extends MenuTankProcess


var hp2_check = 100
var respawning = false
var direction_inputted = false
var rotation_inputted = false
var fire_inputted = false
var explosion2 = false


func _ready():
	# Go to the right place
	position = menu.p2_spawns[menu.selected_menu]


func _process(delta):
	# Run the tank process class function
	# This handles input
	_tank_process(delta, 2, "p2_up", "p2_down", "p2_left", "p2_right", \
	"p2_rotate_left", "p2_rotate_right", "p2_fire")
	
	# Set the right colour
	$Hull.texture = load("res://p" + str(global.p2_colour) + "-tank-hull.png")
	$Turret.texture = load("res://p" + str(global.p2_colour) + "-tank-turret.png")
	$HealthBar.modulate = colours[global.p2_colour - 1]
	
	# The following stuff manages the "tutorial" UI
	# Have any of the directional inputs been made?
	if Input.is_action_just_pressed("p2_up") or Input.is_action_just_pressed("p2_down") or \
	Input.is_action_just_pressed("p2_left") or Input.is_action_just_pressed("p2_right"):
		direction_inputted = true
	
	# Have either of the rotational inputs been made?
	if Input.is_action_just_pressed("p2_rotate_left") or Input.is_action_just_pressed("p2_rotate_right"):
		rotation_inputted = true
	
	# Has the fire input been made?
	if Input.is_action_just_pressed("p2_fire"):
		fire_inputted = true
	
	# Is the P2 tank respawning?
	if not respawning:
		# Is the menu currently switching?
		if not menu.switching:
			$CollisionShape2D.disabled = false
			$Area2D/CollisionShape2D.disabled = false
		# Has P2 died?
			if menu.p2_hp <= 0:
				hide()
				respawning = true
				$Respawn.start(3)
				if not explosion2:
					# Has the explosion started yet?
					# In other words, is this the first frame of death?
					var new_particles = death_particles.instantiate()
					new_particles.global_position = global_position
					add_sibling(new_particles)
					explosion2 = true
					$Explosion.play()
			else:
				show()
				explosion2 = false
		else:
			$CollisionShape2D.disabled = true
			$Area2D/CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = true
		$Area2D/CollisionShape2D.disabled = true
	
	# Has P2 taken damage?
	if hp2_check != menu.p2_hp:
		$Hull.self_modulate = Color(1, 0.5, 0.5)
		$DamageEffect.start(0.1)
	
	$HealthBar.value = menu.p2_hp
	hp2_check = menu.p2_hp


# Reset colour
func _on_damage_effect_timeout():
	$Hull.self_modulate = Color(1, 1, 1)


# Respawn finished
func _on_respawn_timeout():
	position = menu.p2_spawns[menu.selected_menu]
	menu.p2_hp = 100
	show()
	respawning = false

extends TankProcess


var hp1_check = 100
var explosion1 = false


func _ready():
	# Set up P1 tank
	position = main.p1_spawns[main.next_map]
	$Hull.texture = load("res://p" + str(global.p1_colour) + "-tank-hull.png")
	$Turret.texture = load("res://p" + str(global.p1_colour)
			+ "-tank-turret.png")
	$HealthBar.modulate = colours[global.p1_colour - 1]


func _process(delta):
	# Run the tank process class function
	# This handles input
	_tank_process(delta, 1, "p1_up", "p1_down", "p1_left", "p1_right",
			"p1_rotate_left", "p1_rotate_right", "p1_fire")
	
	# Has P1 died?
	if main.p1_hp <= 0:
		hide()
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
	
	# Has P1 taken damage?
	if hp1_check != main.p1_hp:
		$Hull.self_modulate = Color(1, 0.5, 0.5)
		$DamageEffect.start(0.1)
	
	$HealthBar.value = main.p1_hp
	hp1_check = main.p1_hp


# Reset colour
func _on_damage_effect_timeout():
	$Hull.self_modulate = Color(1, 1, 1)


# Finished reloading
func _on_reload_timeout() -> void:
	main.reloading1 = false
	main.ammo1 = main.max_ammo

extends TankProcess


var hp2_check = 100
var explosion2 = false


func _ready():
	# Set up P2 tank
	position = main.p2_spawns[main.next_map]
	$Hull.texture = load("res://p" + str(global.p2_colour) + "-tank-hull.png")
	$Turret.texture = load("res://p" + str(global.p2_colour)
			+ "-tank-turret.png")
	$HealthBar.modulate = colours[global.p2_colour - 1]


func _process(delta):
	# Run the tank process class function
	# This handles input
	_tank_process(delta, 2, "p2_up", "p2_down", "p2_left", "p2_right",
			"p2_rotate_left", "p2_rotate_right", "p2_fire")
	
	# Has P2 died?
	if main.p2_hp <= 0:
		hide()
		if not explosion2:
			# Has the explosion started yet?
			# In other words, is this the first frame of death?
			var new_particles = death_particles.instantiate()
			new_particles.global_position = global_position
			add_sibling(new_particles)
			explosion2 = true
			$Explosion.play()
			get_node("/root/Main/MatchTimer").stop()
	else:
		show()
		explosion2 = false
	
	# Has P2 taken damage?
	if hp2_check != main.p2_hp:
		$Hull.self_modulate = Color(1, 0.5, 0.5)
		$DamageEffect.start(0.1)
	
	$HealthBar.value = main.p2_hp
	hp2_check = main.p2_hp


# Reset colour
func _on_damage_effect_timeout():
	$Hull.self_modulate = Color(1, 1, 1)


# Finished reloading
func _on_reload_timeout() -> void:
	main.reloading2 = false
	main.ammo2 = main.max_ammo

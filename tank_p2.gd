extends TankProcess


var hp2_check = 100
var explosion2 = false


func _ready():
	position = main.p2_spawns[main.next_map]


func _process(delta):
	_tank_process(delta, 2, "p2_up", "p2_down", "p2_left", "p2_right", \
	"p2_rotate_left", "p2_rotate_right", "p2_fire")
	
	# Has died?
	if main.p2_hp <= 0:
		hide()
		if not explosion2:
			var new_particles = death_particles.instantiate()
			new_particles.global_position = global_position
			add_sibling(new_particles)
			explosion2 = true
	else:
		show()
		explosion2 = false
	
	# Has taken damage?
	if hp2_check != main.p2_hp:
		$Hull.self_modulate = Color(1, 0.5, 0.5)
		$DamageEffect.start(0.1)
	
	$HealthBar.value = main.p2_hp
	hp2_check = main.p2_hp


func _on_damage_effect_timeout():
	$Hull.self_modulate = Color(1, 1, 1)


func _on_reload_timeout() -> void:
	main.reloading2 = false
	main.ammo2 = main.max_ammo

extends TankProcess


var hp1_check = 100
var explosion1 = false

func _ready():
	position = main.p1_spawns[main.next_map]
	$Hull.texture = load("res://p" + str(global.p1_colour) + "-tank-hull.png")
	$Turret.texture = load("res://p" + str(global.p1_colour) + "-tank-turret.png")
	$HealthBar.modulate = colours[global.p1_colour - 1]


func _process(delta):
	_tank_process(delta, 1, "p1_up", "p1_down", "p1_left", "p1_right", \
	"p1_rotate_left", "p1_rotate_right", "p1_fire")
	
	# Has died?
	if main.p1_hp <= 0:
		hide()
		if not explosion1:
			var new_particles = death_particles.instantiate()
			new_particles.global_position = global_position
			add_sibling(new_particles)
			explosion1 = true
	else:
		show()
		explosion1 = false
	
	# Has taken damage?
	if hp1_check != main.p1_hp:
		$Hull.self_modulate = Color(1, 0.5, 0.5)
		$DamageEffect.start(0.1)
	
	$HealthBar.value = main.p1_hp
	hp1_check = main.p1_hp


func _on_damage_effect_timeout():
	$Hull.self_modulate = Color(1, 1, 1)


func _on_reload_timeout() -> void:
	main.reloading1 = false
	main.ammo1 = main.max_ammo

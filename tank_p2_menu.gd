extends MenuTankProcess


var hp2_check = 100
var respawning = false
var direction_inputted = false
var rotation_inputted = false
var fire_inputted = false
var explosion2 = false


func _ready():
	position = menu.p2_spawns[menu.selected_menu]


func _process(delta):
	_tank_process(delta, 2, "p2_up", "p2_down", "p2_left", "p2_right", \
	"p2_rotate_left", "p2_rotate_right", "p2_fire")
	
	$Hull.texture = load("res://p" + str(global.p2_colour) + "-tank-hull.png")
	$Turret.texture = load("res://p" + str(global.p2_colour) + "-tank-turret.png")
	$HealthBar.modulate = colours[global.p2_colour - 1]
	
	if Input.is_action_just_pressed("p2_up") or Input.is_action_just_pressed("p2_down") or \
	Input.is_action_just_pressed("p2_left") or Input.is_action_just_pressed("p2_right"):
		direction_inputted = true
	
	if Input.is_action_just_pressed("p2_rotate_left") or Input.is_action_just_pressed("p2_rotate_right"):
		rotation_inputted = true
	
	if Input.is_action_just_pressed("p2_fire"):
		fire_inputted = true
	
	if not respawning:
		if not menu.switching:
			$CollisionShape2D.disabled = false
			$Area2D/CollisionShape2D.disabled = false
		# Has died?
			if menu.p2_hp <= 0:
				hide()
				respawning = true
				$Respawn.start(3)
				if not explosion2:
					var new_particles = death_particles.instantiate()
					new_particles.global_position = global_position
					add_sibling(new_particles)
					explosion2 = true
			else:
				show()
				explosion2 = false
		else:
			$CollisionShape2D.disabled = true
			$Area2D/CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = true
		$Area2D/CollisionShape2D.disabled = true
	
	# Has taken damage?
	if hp2_check != menu.p2_hp:
		$Hull.self_modulate = Color(1, 0.5, 0.5)
		$DamageEffect.start(0.1)
	
	$HealthBar.value = menu.p2_hp
	hp2_check = menu.p2_hp


func _on_damage_effect_timeout():
	$Hull.self_modulate = Color(1, 1, 1)


func _on_respawn_timeout():
	position = menu.p2_spawns[menu.selected_menu]
	menu.p2_hp = 100
	show()
	respawning = false

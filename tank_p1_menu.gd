extends MenuTankProcess


var hp1_check = 100
var respawning = false


func _ready():
	position = menu.p1_spawns[menu.selected_menu]


func _process(delta):
	_tank_process(delta, 1, "p1_up", "p1_down", "p1_left", "p1_right", \
	"p1_rotate_left", "p1_rotate_right", "p1_fire")
	
	if not respawning:
		if not menu.switching:
			$CollisionShape2D.disabled = false
			$Area2D/CollisionShape2D.disabled = false
		# Has died?
			if menu.p1_hp <= 0:
				hide()
				respawning = true
				$Respawn.start(3)
			else:
				show()
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


func _on_damage_effect_timeout():
	$Hull.self_modulate = Color(1, 1, 1)


func _on_respawn_timeout():
	position = menu.p1_spawns[menu.selected_menu]
	menu.p1_hp = 100
	show()
	$CollisionShape2D.disabled = false
	$Area2D/CollisionShape2D.disabled = false
	respawning = false
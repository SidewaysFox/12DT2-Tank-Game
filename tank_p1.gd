extends TankProcess


var hp1_check = 100


func _ready():
	position = main.p1_spawns[main.next_map]


func _process(delta):
	_tank_process(delta, 1, "p1_up", "p1_down", "p1_left", "p1_right", \
	"p1_rotate_left", "p1_rotate_right", "p1_fire")
	
	# Has died?
	if main.p1_hp <= 0:
		hide()
	else:
		show()
	
	# Has taken damage?
	if hp1_check != main.p1_hp:
		$Hull.self_modulate = Color(1, 0.5, 0.5)
		$DamageEffect.start(0.1)
	
	$HealthBar.value = main.p1_hp
	hp1_check = main.p1_hp


func _on_damage_effect_timeout():
	$Hull.self_modulate = Color(1, 1, 1)

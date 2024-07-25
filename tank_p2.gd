extends TankProcess


var hp2_check = 100


func _ready():
	position = main.p2_spawns[main.next_map]


func _process(delta):
	_tank_process(delta, 2, "p2_up", "p2_down", "p2_left", "p2_right", \
	"p2_rotate_left", "p2_rotate_right", "p2_fire")
	
	# Has died?
	if main.p2_hp <= 0:
		hide()
	else:
		show()
	
	# Has taken damage?
	if hp2_check != main.p2_hp:
		$Hull.self_modulate = Color(1, 0.5, 0.5)
		$DamageEffect.start(0.1)
	hp2_check = main.p2_hp


func _on_damage_effect_timeout():
	$Hull.self_modulate = Color(1, 1, 1)

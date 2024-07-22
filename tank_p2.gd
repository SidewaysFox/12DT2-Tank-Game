extends TankProcess


func _ready():
	position = main.p2_spawns[main.next_map]


func _process(delta):
	_tank_process(delta, 2, "p2_up", "p2_down", "p2_left", "p2_right", \
	"p2_rotate_left", "p2_rotate_right", "p2_fire")
	if main.p2_hp <= 0:
		hide()
	else:
		show()

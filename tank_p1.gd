extends TankProcess


func _ready():
	position = main.p1_spawns[main.next_map]


func _process(delta):
	_tank_process(delta, 1, "p1_up", "p1_down", "p1_left", "p1_right", \
	"p1_rotate_left", "p1_rotate_right", "p1_fire")
	if main.p1_hp <= 0:
		hide()
	else:
		show()

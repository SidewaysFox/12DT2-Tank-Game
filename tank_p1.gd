extends TankProcess


func _process(delta):
	_tank_process(delta, "p1_up", "p1_down", "p1_left", "p1_right", \
	"p1_rotate_left", "p1_rotate_right", "p1_fire")

extends Node2D


@onready var menu = get_node("/root/Menu/")
@onready var p1 = get_node("/root/Menu/TankP1Menu/")
@onready var p2 = get_node("/root/Menu/TankP2Menu/")


func _process(delta):
	if p1.direction_inputted:
		$P1Label.hide()
	if p2.direction_inputted:
		$P2Label.hide()
	
	if p1.direction_inputted and p1.rotation_inputted and p1.fire_inputted:
		$P1Controls.hide()
	if p2.direction_inputted and p2.rotation_inputted and p2.fire_inputted:
		$P2Controls.hide()

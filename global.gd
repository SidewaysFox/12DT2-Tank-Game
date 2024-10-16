extends Node


var score = Vector2(0, 0)
var volume = 100.0
var timer_on = true
var timer_time = 60
var max_ammo = 20
var reload = 4
var p1_colour = 1
var p2_colour = 2
var bus = AudioServer.get_bus_index("Master")


func _process(_delta):
	# Set audio volume
	AudioServer.set_bus_volume_db(bus, linear_to_db(volume / 100))

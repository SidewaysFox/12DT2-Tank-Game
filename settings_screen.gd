extends Node2D


@onready var menu = get_node("/root/Menu/")
@onready var global = get_node("/root/Global/")
@onready var timeron = preload("res://timer-on.png")
@onready var timeroff = preload("res://timer-off.png")


func _process(_delta):
	# Has the back button been pressed?
	if menu.back_hp > 0:
		$BackButton/Sprite2D.texture = load("res://menu-back-button-" + \
		str(menu.back_hp) + ".png")
	else:
		$BackButton.hide()
	
	# Is the timer on?
	if global.timer_on:
		$TimerOnOff/Sprite2D.texture = timeron
	else:
		$TimerOnOff/Sprite2D.texture = timeroff
	
	# Set the text
	$Volume.text = "Volume:\n" + str(global.volume)
	$TimerTime.text = "Time:\n" + str(global.timer_time)
	$AmmoCount.text = "Ammo:\n" + str(global.max_ammo)

extends Node2D


@onready var menu = get_node("/root/Menu/")


func _process(_delta):
	# Has the back button been fully pressed?
	if menu.back_hp > 0:
		# Set back button sprite based on its HP
		$BackButton/Sprite2D.texture = load("res://menu-back-button-" + str(menu.back_hp) + ".png")
	else:
		$BackButton.hide()

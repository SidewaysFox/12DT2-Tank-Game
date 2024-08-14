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
	
	if menu.push_hint:
		$PushHint.show()
	else:
		$PushHint.hide()
	
	if menu.play_hp > 0:
		$PlayButton/Sprite2D.texture = load("res://menu-play-button-" + str(menu.play_hp) + ".png")
	else:
		$PlayButton.hide()
	
	if menu.settings_hp > 0:
		$SettingsButton/Sprite2D.texture = load("res://menu-settings-button-" + str(menu.settings_hp) + ".png")
	else:
		$SettingsButton.hide()
	
	if menu.credits_hp > 0:
		$CreditsButton/Sprite2D.texture = load("res://menu-credits-button-" + str(menu.credits_hp) + ".png")
	else:
		$CreditsButton.hide()
	
	if menu.quit_hp > 0:
		$QuitButton/Sprite2D.texture = load("res://menu-quit-button-" + str(menu.quit_hp) + ".png")
	else:
		$QuitButton.hide()

extends Node2D


@onready var menu = get_node("/root/Menu/")
@onready var p1 = get_node("/root/Menu/TankP1Menu/")
@onready var p2 = get_node("/root/Menu/TankP2Menu/")
var repeat = 0


func _process(_delta):
	# Have the players made directional inputs?
	if p1.direction_inputted:
		$P1Label.hide()
		$Arrows1.hide()
	if p2.direction_inputted:
		$P2Label.hide()
		$Arrows2.hide()
	
	# Have the players made all kinds of inputs?
	if p1.direction_inputted and p1.rotation_inputted and p1.fire_inputted:
		$P1Controls.hide()
	if p2.direction_inputted and p2.rotation_inputted and p2.fire_inputted:
		$P2Controls.hide()
	
	# Has a button been pushed?
	if menu.push_hint:
		$PushHint.show()
	else:
		$PushHint.hide()
	
	# Play button pushing
	if menu.play_hp > 0:
		$PlayButton/Sprite2D.texture = load("res://menu-play-button-"
				+ str(menu.play_hp) + ".png")
	else:
		$PlayButton.hide()
	
	# Settings button pushing
	if menu.settings_hp > 0:
		$SettingsButton/Sprite2D.texture = load("res://menu-settings-button-"
				+ str(menu.settings_hp) + ".png")
	else:
		$SettingsButton.hide()
	
	# Credits button pushing
	if menu.credits_hp > 0:
		$CreditsButton/Sprite2D.texture = load("res://menu-credits-button-"
				+ str(menu.credits_hp) + ".png")
	else:
		$CreditsButton.hide()
	
	# Quit button pushing
	if menu.quit_hp > 0:
		$QuitButton/Sprite2D.texture = load("res://menu-quit-button-"
				+ str(menu.quit_hp) + ".png")
	else:
		$QuitButton.hide()


# Flashing UI elements to make them more visible
func _on_push_hint_flash_timeout():
	if repeat <= 10:
		if repeat % 2 == 0:
			$PushHint.self_modulate = Color(1, 1, 1, 1)
			$Arrows1.self_modulate = Color(1, 1, 1, 1)
			$Arrows2.self_modulate = Color(1, 1, 1, 1)
		else:
			$PushHint.self_modulate = Color(1, 1, 1, 0.5)
			$Arrows1.self_modulate = Color(1, 1, 1, 0.5)
			$Arrows2.self_modulate = Color(1, 1, 1, 0.5)
		repeat += 1
	else:
		$PushHintFlash.stop()

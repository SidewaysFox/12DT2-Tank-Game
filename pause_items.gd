extends Control


func _ready():
	$Paused.hide()
	$Blur.hide()


func _on_pause_button_pressed():
	if get_tree().paused:
		get_tree().paused = false
		$Paused.hide()
		$Blur.hide()
	else:
		get_tree().paused = true
		$Paused.show()
		$Blur.show()


func _on_resume_pressed():
	print("pressed")
	_on_pause_button_pressed()


func _on_settings_pressed():
	pass


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")

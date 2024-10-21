extends Control


@onready var global = get_node("/root/Global")


func _ready():
	# Hide everything
	$Paused.hide()
	$AltSettings.hide()
	$Blur.hide()


func _on_pause_button_pressed():
	# Is it pausing or unpausing?
	# Resume button also connects to this for functionality
	if get_tree().paused:
		get_tree().paused = false
		$Paused.hide()
		$Blur.hide()
	else:
		get_tree().paused = true
		$Paused.show()
		$Blur.show()


func _on_settings_pressed():
	# Go to settings pause menu
	$Paused.hide()
	$AltSettings.show()


func _on_menu_pressed():
	# Go to menu
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_back_pressed() -> void:
	# Go back from settings pause menu
	$AltSettings.hide()
	$Paused.show()


func _on_volume_up_pressed() -> void:
	# Volume up
	if global.volume < 91:
		global.volume += 10


func _on_volume_down_pressed() -> void:
	# Volume down
	if global.volume > 9:
		global.volume -= 10

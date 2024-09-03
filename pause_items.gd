extends Control


@onready var global = get_node("/root/Global")


func _ready():
	$Paused.hide()
	$AltSettings.hide()
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
	$Paused.hide()
	$AltSettings.show()


func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_back_pressed() -> void:
	$AltSettings.hide()
	$Paused.show()


func _on_volume_up_pressed() -> void:
	if global.volume < 91:
		global.volume += 10


func _on_volume_down_pressed() -> void:
	if global.volume > 9:
		global.volume -= 10

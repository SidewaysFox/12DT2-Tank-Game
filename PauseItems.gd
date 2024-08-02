extends Control


func _ready():
	$Paused.hide()


func _on_pause_button_pressed():
	if get_tree().paused:
		get_tree().paused = false
		$Paused.hide()
	else:
		get_tree().paused = true
		$Paused.show()

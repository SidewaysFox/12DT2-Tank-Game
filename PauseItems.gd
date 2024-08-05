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

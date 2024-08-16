extends Node2D


@onready var global = get_node("/root/Global")
var position1: Vector2
var position2: Vector2
var player: int
var active = false
var slide = 0


func _up_score(winner):
	player = winner
	active = true
	slide = 1


func _process(delta):
	%P1Label/P1Score.text = str(global.score.x)
	%P2Label/P2Score.text = str(global.score.y)
	
	if active:
		# Slide in
		if slide == 1 and %P1Label.global_position.y < 79:
			%P1Label.global_position = lerp(%P1Label.global_position, Vector2(890, 80), 0.15)
			%P2Label.global_position = lerp(%P2Label.global_position, Vector2(890, 865), 0.15)
		elif slide == 1 and %P1Label.global_position.y >= 79:
			slide = 0
			%P1Label.global_position = Vector2(890, 80)
			%P2Label.global_position = Vector2(890, 865)
			$Timer1.start(0.4)
		# Slide out
		if slide == 2 and %P1Label.global_position.y > -264:
			%P1Label.global_position = lerp(%P1Label.global_position, Vector2(890, -265), 0.15)
			%P2Label.global_position = lerp(%P2Label.global_position, Vector2(890, 1210), 0.15)
		elif slide == 2 and %P1Label.global_position.y <= -264:
			slide = 0
			%P1Label.global_position = Vector2(890, -265)
			%P2Label.global_position = Vector2(890, 1210)
			active = false


func _on_timer_1_timeout():
	# Add score
	if player == 1:
		global.score.x += 1
	else:
		global.score.y += 1
	$Timer2.start(0.6)


func _on_timer_2_timeout():
	# Begin sliding out of screen
	slide = 2

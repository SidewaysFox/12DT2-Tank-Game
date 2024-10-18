extends Node2D


@onready var global = get_node("/root/Global")
var particle = GPUParticles2D
var position1: Vector2
var position2: Vector2
var player: int
var active = false
var slide = 0
var colours = [
	Color(1,0.3137,0,0.9176), # Orange
	Color(0,0.3137,1,0.9176), # Blue
	Color(0,1,0.3137,0.9176), # Green
	Color(1,1,0.3137,0.9176), # Yellow
	Color(0.7843,0.7843,0.7843,0.9176), # Grey
	Color(0.3137,0,1,0.9176), # Purple
	Color(1,0,0.3137,0.9176), # Pink
]


func _up_score(winner):
	player = winner
	active = true
	slide = 1


func _ready() -> void:
	$CanvasLayer/P1Label.add_theme_color_override("font_color", \
	colours[global.p1_colour - 1])
	$CanvasLayer/P2Label.add_theme_color_override("font_color", \
	colours[global.p2_colour - 1])


func _process(_delta):
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

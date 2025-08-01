extends CPUParticles2D


@onready var main = get_node("/root/Main/")
@onready var scores = get_node("/root/Main/Scores/")


func _process(_delta: float) -> void:
	# Are we switching maps?
	if main.switching and not scores.active:
		queue_free()

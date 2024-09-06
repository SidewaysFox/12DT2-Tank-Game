extends GPUParticles2D


@onready var main = get_node("/root/Main/")
@onready var scores = get_node("/root/Main/Scores/")


func _process(_delta: float) -> void:
	if main.switching and not scores.active:
		_on_finished()


func _on_finished() -> void:
	queue_free()

extends GPUParticles2D


@onready var menu = get_node("/root/Menu/")


func _process(_delta: float) -> void:
	if menu.switching:
		queue_free()

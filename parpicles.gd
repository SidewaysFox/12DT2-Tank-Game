extends GPUParticles2D


func _ready() -> void:
	print("emitted")
	


func _on_finished() -> void:
	print("freed")
	queue_free()

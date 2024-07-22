extends CharacterBody2D


@onready var main = get_node("/root/Main/")
@export var projectile_speed = 5000
var direction: Vector2


func _ready():
	direction = Vector2(1, 0).rotated(rotation)


func _process(delta):
	velocity += direction * projectile_speed * delta
	move_and_slide()


func _on_area_2d_area_entered(area):
	if area.has_meta("projectile"):
		queue_free()


func _on_area_2d_body_entered(body):
	if not body.has_meta("projectile"):
		if body.has_meta("p1"):
			main.p1_hp -= randi_range(15, 20)
		if body.has_meta("p2"):
			main.p2_hp -= randi_range(15, 20)
		queue_free()

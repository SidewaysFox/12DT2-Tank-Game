extends CharacterBody2D


@onready var main = get_node("/root/Main/")
@export var projectile_speed = 100000
@export var particles: PackedScene
var direction: Vector2


func _ready():
	direction = Vector2(1, 0).rotated(rotation)


func _process(delta):
	# Go forth, my sweet rectangles
	velocity = direction * projectile_speed * delta
	move_and_slide()


func _on_area_2d_area_entered(area):
	# Collision with another projectile
	if area.has_meta("projectile"):
		queue_free()


func _on_area_2d_body_entered(body):
	# What did it just collide with?
	if not body.has_meta("projectile"):
		if body.has_meta("p1"):
			# Reduce P1 HP
			main.p1_hp -= randi_range(15, 20)
		if body.has_meta("p2"):
			# Reduce P2 HP
			main.p2_hp -= randi_range(15, 20)
		# Spawn particles and delete
		var new = particles.instantiate()
		new.global_rotation = global_rotation
		new.global_position = global_position
		add_sibling(new)
		queue_free()

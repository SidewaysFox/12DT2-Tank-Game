class_name TankProcess extends CharacterBody2D


@export var move_speed = 300.0
@export var acceleration = Vector2(0.05, 0.05)
@export var friction = 0.02
@export var turret_rotate_speed = 3.0
@export var projectile: PackedScene
@export var spread = 2.0
@export var reload_time = 5.0
var current_accel = Vector2(0.0, 0.0)


func _tank_process(delta, up, down, left, right, rotate_left, rotate_right, \
fire):
	velocity = Vector2.ZERO
	
	# Y-axis movement
	if Input.is_action_pressed(down):
		if current_accel.y < 1:
			current_accel.y += acceleration.y
	if Input.is_action_pressed(up):
		if current_accel.y > -1:
			current_accel.y -= acceleration.y
	
	# X-axis movement
	if Input.is_action_pressed(right):
		if current_accel.x < 1:
			current_accel.x += acceleration.x
	if Input.is_action_pressed(left):
		if current_accel.x > -1:
			current_accel.x -= acceleration.x
	
	# If not moving on X-axis, apply friction
	if current_accel.x != 0 and not Input.is_action_pressed(right) \
	and not Input.is_action_pressed(left):
		current_accel.x = move_toward(current_accel.x, 0, friction)
	
	# If not moving on Y-axis, apply friction
	if current_accel.y != 0 and not Input.is_action_pressed(up) \
	and not Input.is_action_pressed(down):
		current_accel.y = move_toward(current_accel.y, 0, friction)
	
	# Calculate total velocity and move the tank
	velocity = Vector2(1, 1).normalized() \
	* Vector2(move_speed * current_accel.x, move_speed * current_accel.y)
	move_and_slide()
	
	# Turret rotation
	if Input.is_action_pressed(rotate_right):
		$Turret.rotation += turret_rotate_speed * delta
	if Input.is_action_pressed(rotate_left):
		$Turret.rotation -= turret_rotate_speed * delta
	
	# Firing
	if Input.is_action_just_pressed(fire):
		var new_projectile = projectile.instantiate()
		new_projectile.global_position = $Turret/ProjectileSpawn.global_position
		new_projectile.rotation_degrees = $Turret.global_rotation_degrees \
		- randf_range(90 - spread, 90 + spread)
		add_sibling(new_projectile)

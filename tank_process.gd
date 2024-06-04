class_name TankProcess extends CharacterBody2D


@export var move_speed = 300.0
@export var x_acceleration = 0.05
@export var y_acceleration = 0.05
@export var friction = 0.02
@export var turret_rotate_speed = 3.0
@export var projectile: PackedScene
@export var spread = 2.0
@export var reload_time = 5.0
var x_current_accel = 0.0
var y_current_accel = 0.0
var moving = false


func _tank_process(delta, up, down, left, right, \
rotate_left, rotate_right, fire):
	velocity = Vector2.ZERO
	
	# Y-axis movement
	if Input.is_action_pressed(down):
		if y_current_accel < 1:
			y_current_accel += y_acceleration
	if Input.is_action_pressed(up):
		if y_current_accel > -1:
			y_current_accel -= y_acceleration
	
	# X-axis movement
	if Input.is_action_pressed(right):
		if x_current_accel < 1:
			x_current_accel += x_acceleration
	if Input.is_action_pressed(left):
		if x_current_accel > -1:
			x_current_accel -= x_acceleration
	
	# If not moving on X-axis, apply friction
	if x_current_accel != 0 and not Input.is_action_pressed(right) \
	and not Input.is_action_pressed(left):
		x_current_accel = move_toward(x_current_accel, 0, friction)
	
	# If not moving on Y-axis, apply friction
	if y_current_accel != 0 and not Input.is_action_pressed(up) \
	and not Input.is_action_pressed(down):
		y_current_accel = move_toward(y_current_accel, 0, friction)
	
	# Calculate total velocity and move the tank
	velocity = Vector2(move_speed * x_current_accel, move_speed * y_current_accel)
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
		new_projectile.rotation_degrees = $Turret.global_rotation_degrees - randf_range(90 - spread, 90 + spread)
		add_sibling(new_projectile)

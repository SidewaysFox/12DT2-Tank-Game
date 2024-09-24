class_name MenuTankProcess extends CharacterBody2D


@onready var global = get_node("/root/Global/")
@onready var menu = get_node("/root/Menu/")
@export var projectile: PackedScene
const MOVE_SPEED = 400.0
const ACCELERATION = Vector2(0.05, 0.05)
const FRICTION = 0.02
const TURRET_ROTATE_SPEED = 3.0
const SPREAD = 1.0
const RELOAD_TIME = 5.0
var current_accel = Vector2(0.0, 0.0)
var colours = [
	Color(1,0.3137,0,0.9176),
	Color(0,0.3137,1,0.9176),
	Color(0,1,0.3137,0.9176),
	Color(1,1,0.3137,0.9176),
	Color(0.7843,0.7843,0.7843,0.9176),
	Color(0.3137,0,1,0.9176),
	Color(1,0,0.3137,0.9176),
]


func _tank_process(delta, id, up, down, left, right, rotate_left, \
rotate_right, fire):
	velocity = Vector2.ZERO
	
	# Make sure maps aren't switching
	if not menu.switching:
		# Y-axis movement
		if Input.is_action_pressed(down):
			if current_accel.y < 1:
				current_accel.y += ACCELERATION.y
		if Input.is_action_pressed(up):
			if current_accel.y > -1:
				current_accel.y -= ACCELERATION.y
		
		# X-axis movement
		if Input.is_action_pressed(right):
			if current_accel.x < 1:
				current_accel.x += ACCELERATION.x
		if Input.is_action_pressed(left):
			if current_accel.x > -1:
				current_accel.x -= ACCELERATION.x
		
		# If not moving on X-axis, apply friction
		if current_accel.x != 0 and not Input.is_action_pressed(right) \
		and not Input.is_action_pressed(left):
			current_accel.x = move_toward(current_accel.x, 0, FRICTION)
		
		# If not moving on Y-axis, apply friction
		if current_accel.y != 0 and not Input.is_action_pressed(up) \
		and not Input.is_action_pressed(down):
			current_accel.y = move_toward(current_accel.y, 0, FRICTION)
		
		# Calculate total velocity and move the tank
		velocity = Vector2(1, 1).normalized() \
		* Vector2(MOVE_SPEED * current_accel.x, MOVE_SPEED * current_accel.y)
		move_and_slide()
		
		# Turret rotation
		if Input.is_action_pressed(rotate_right):
			$Turret.rotation += TURRET_ROTATE_SPEED * delta
		if Input.is_action_pressed(rotate_left):
			$Turret.rotation -= TURRET_ROTATE_SPEED * delta
		
		# Firing
		if Input.is_action_just_pressed(fire):
			var new_projectile = projectile.instantiate()
			new_projectile.global_position = $Turret/ProjectileSpawn.global_position
			new_projectile.rotation_degrees = $Turret.global_rotation_degrees \
			- randf_range(90 - SPREAD, 90 + SPREAD)
			new_projectile.origin = id
			add_sibling(new_projectile)
	
	# Maps are switching
	elif menu.switching:
		if id == 1:
			position = lerp(position, menu.p1_spawns[menu.selected_menu], 0.1)
		else:
			position = lerp(position, menu.p2_spawns[menu.selected_menu], 0.1)

class_name TankProcess extends CharacterBody2D


@onready var global = get_node("/root/Global/")
@onready var main = get_node("/root/Main/")
@onready var scores = get_node("/root/Main/Scores/")
@export var projectile: PackedScene
@export var firing_particles: PackedScene
@export var death_particles: PackedScene
const MOVE_SPEED = 400.0
const ACCELERATION = Vector2(0.05, 0.05)
const FRICTION = 0.02
const TURRET_ROTATE_SPEED = 3.0
const SPREAD = 1.0
const RELOAD_TIME = 5.0
var current_accel = Vector2(0.0, 0.0)
var fire_input
var colours = [
	Color(1,0.3137,0,0.9176), # Orange
	Color(0,0.3137,1,0.9176), # Blue
	Color(0,1,0.3137,0.9176), # Green
	Color(1,1,0.3137,0.9176), # Yellow
	Color(0.7843,0.7843,0.7843,0.9176), # Grey
	Color(0.3137,0,1,0.9176), # Purple
	Color(1,0,0.3137,0.9176), # Pink
]



func _tank_process(delta, id, up, down, left, right, rotate_left, \
rotate_right, fire):
	velocity = Vector2.ZERO
	fire_input = fire
	
	# Make sure maps aren't switching
	if not main.switching and not scores.active:
		$CollisionShape2D.disabled = false
		queue_redraw()
		
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
		
		# Which tank is this?
		if id == 1:
			# Does it have ammo?
			if main.ammo1 > 0:
				_trigger(1)
				$Ammo.text = str(main.ammo1)
			elif not main.reloading1:
				$Reload.start(main.reload)
				$Ammo.text = "RELOADING"
				main.reloading1 = true
		else:
			# Does it have ammo?
			if main.ammo2 > 0:
				_trigger(2)
				$Ammo.text = str(main.ammo2)
			elif not main.reloading2:
				$Reload.start(main.reload)
				$Ammo.text = "RELOADING"
				main.reloading2 = true
	
	# Maps are switching
	elif main.switching and not scores.active:
		$CollisionShape2D.disabled = true
		if id == 1:
			position = lerp(position, main.p1_spawns[main.next_map], 0.1)
		else:
			position = lerp(position, main.p2_spawns[main.next_map], 0.1)


# Draw the aiming line
func _draw():
	draw_line(Vector2(0,0), to_local($Turret/RayCast2D.get_collision_point()), \
	Color(255, 255, 255, 0.5), 3.0)


func _trigger(id):
	# Are we supposed to fire?
	if Input.is_action_just_pressed(fire_input):
		# Set up new projectile and particles
		var new_projectile = projectile.instantiate()
		var new_particles = firing_particles.instantiate()
		# Projectile
		new_projectile.global_position = $Turret/ProjectileSpawn.global_position
		new_projectile.rotation_degrees = $Turret.global_rotation_degrees \
		- randf_range(90 - SPREAD, 90 + SPREAD)
		# Particles
		new_particles.global_position = $Turret/ProjectileSpawn.global_position
		new_particles.rotation_degrees = $Turret.global_rotation_degrees - 90
		# Go, my beauties
		add_sibling(new_projectile)
		add_sibling(new_particles)
		# Make a sound
		$CannonFire.pitch_scale = randf_range(0.7, 1.5)
		$CannonFire.play()
		# Reduce ammo count
		if id == 1:
			main.ammo1 -= 1
		else:
			main.ammo2 -= 1

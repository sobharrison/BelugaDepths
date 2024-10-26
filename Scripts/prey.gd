extends CharacterBody2D


const SPEED = 5.0
const VELOCITY_MAX = 20

var timer: int = 0
var rng
var beluga
var sprite

func _ready():
	self.visible = false
	rng = RandomNumberGenerator.new()
	beluga = self.get_parent().get_parent().find_child("Beluga2D")
	sprite = self.find_child("Sprite2D")

func _physics_process(delta: float) -> void:
	hide_me()
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	#move_and_slide()
	
	if self.visible:
		# run from player
		var player_angle = self.position.angle_to_point(beluga.position)
		var run = Vector2.from_angle(player_angle) * SPEED
		var temprun = run.x
		run.x = run.y
		run.y = temprun
		velocity += run
	else:
		# safe, wander
		velocity.x += rng.randi_range(-SPEED, SPEED)
		velocity.y += rng.randi_range(-SPEED, SPEED)
		# Max Velocity
		velocity = velocity.limit_length(VELOCITY_MAX)
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		
		# eaten by predator
		if collision_info.get_collider().get_collision_layer() == 8:
			eat_me()
	
	if velocity.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func hide_me() -> void:
	var current = Time.get_ticks_msec()
	if timer < current:
		self.visible = false

func found_me() -> void:
	self.visible = true
	self.timer = Time.get_ticks_msec() + 2000

func eat_me() -> void:
	self.queue_free()

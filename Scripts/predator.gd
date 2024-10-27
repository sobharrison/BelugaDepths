extends CharacterBody2D

var plan_direction: Vector2 = Vector2(0, 0)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const despawn: int = 60000
var spawn_time: int

var timer: int = 0

func _ready():
	self.visible = false
	spawn_time = Time.get_ticks_msec()

func _physics_process(delta: float) -> void:
	hide_me()
	despawn_me()
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

	velocity = plan_direction * SPEED

	#move_and_slide()
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		
		# eat the prey
		if collision_info.get_collider().get_collision_layer() == 4:
			collision_info.get_collider().eat_me()

func hide_me() -> void:
	var current = Time.get_ticks_msec()
	if timer < current:
		self.visible = false
	
func found_me() -> void:
	self.visible = true
	self.timer = Time.get_ticks_msec() + 5000

func despawn_me() -> void:
	if spawn_time + despawn < Time.get_ticks_msec():
		self.queue_free()

func despawn_me_now() -> void:
	self.queue_free()

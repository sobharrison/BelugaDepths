extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
#	if not is_on_floor():
#		velocity += get_gravity() * delta

	# Handle jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionx := Input.get_axis("ui_left", "ui_right")
	if directionx:
		velocity.x += directionx * SPEED * delta
	else:
		pass
		#velocity.x = move_toward(velocity.x, 0, 0.5*SPEED)
	
	var directiony := Input.get_axis("ui_up", "ui_down")
	if directiony:
		velocity.y += directiony * SPEED * delta
	else:
		pass
		#velocity.y = move_toward(velocity.y, 0, 0.5*SPEED)

	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		print_rich("[color=RED][pulse freq=2.5]Collision!!![/pulse][/color]", collision_info,
			"  [color=RED][pulse freq=2.5]ID:[/pulse][/color]", collision_info.get_collider(),
			"  [color=RED][pulse freq=2.5]Layer:[/pulse][/color]",collision_info.get_collider().get_collision_layer()
		)

		velocity = velocity.bounce(collision_info.get_normal())

	#print_rich("[rainbow freq=1.0 sat=0.8 val=0.8]x[/rainbow]", velocity.x, "[rainbow freq=1.0 sat=0.8 val=0.8]y[/rainbow]", velocity.y)

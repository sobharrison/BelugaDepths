extends CharacterBody2D

const SPEED: float = 300.0
const FRICTION: float = 50.0
const VELOCITY_MAX: float = 1000.0
const BOOST_MULTIPLIER_S: float = 1.30
const BOOST_MULTIPLIER_M: float = 1.75
const BOOST_TIME_MIN: int = 500
const BOOST_TIME_IDEAL: int = 700
const BOOST_TIME_MAX: int = 1000
var last_boost: int
var last_boost_type = ''
const LAST_BOOST: int = 400

const ECHO_DISTANCE = 500.0

@export var multimesh: MultiMeshInstance2D

var my_path: Array = []
const FOLLOW_PATH: int = 20
var my_head
var my_torso
var my_tail

var my_life3
var my_life2
var my_life1

var my_health: int = 3 

var score: int = 0

var gameOverGUI
var gameOverScore
var gameState = true

func _ready():
	multimesh.clip_children = CanvasItem.CLIP_CHILDREN_ONLY
	
	my_head = self.find_child("Head")
	my_torso = self.find_child("LowerBody").find_child("Torso")
	my_tail = self.find_child("LowerBody").find_child("Tail")
	
	my_life1 = self.find_child("Health").find_child("Life1")
	my_life2 = self.find_child("Health").find_child("Life2")
	my_life3 = self.find_child("Health").find_child("Life3")
	
	score = 0
	
	gameOverGUI = self.find_child("GameOverGUI")
	gameOverGUI.visible = false
	gameOverScore = gameOverGUI.find_child("score")
	
	gameState = true

func _physics_process(delta: float) -> void:
	
	if !gameState:
		velocity.x = 0
		velocity.y = 0
		if Input.is_action_just_pressed("ui_accept"):
			restart()
	
	# Basic movement
	var directionx := Input.get_axis("ui_left", "ui_right")
	if directionx:
		velocity.x += directionx * SPEED * delta
	else:
		velocity.x = sign(velocity.x) * ( abs(velocity.x) - FRICTION * delta)
	
	var directiony := Input.get_axis("ui_up", "ui_down")
	if directiony:
		velocity.y += directiony * SPEED * delta
	else:
		velocity.y = sign(velocity.y) * ( abs(velocity.y) - FRICTION * delta)

	# Setup for vision/echolocation
	var player_vision: Vector2 = Vector2(directionx, directiony)
	
	# flip sprite
	if velocity.x > 0:
		my_head.get_child(0).flip_h = false
		my_torso.get_child(0).flip_h = false
		my_tail.get_child(0).flip_h = false
	else:
		my_head.get_child(0).flip_h = true
		my_torso.get_child(0).flip_h = true
		my_tail.get_child(0).flip_h = true

	# Booster
	var booster := Input.is_action_just_pressed("ui_accept")
	var current_time = Time.get_ticks_msec()
	if booster:
		if last_boost+BOOST_TIME_IDEAL < current_time && current_time < last_boost+BOOST_TIME_MAX:
			print_rich("[color=GREEN][pulse freq=5]MEGA BOOST[/pulse][/color]")
			velocity.x *= BOOST_MULTIPLIER_M
			velocity.y *= BOOST_MULTIPLIER_M
			last_boost_type = 'M'
		elif last_boost+BOOST_TIME_MIN < current_time:
			print_rich("[color=BLUE][pulse freq=5]small boost[/pulse][/color]")
			velocity.x *= BOOST_MULTIPLIER_S
			velocity.y *= BOOST_MULTIPLIER_S
			last_boost_type = 'S'
		last_boost = Time.get_ticks_msec()
	else:
		if current_time > last_boost+LAST_BOOST:
			if last_boost_type == 'M':
				velocity.x /= BOOST_MULTIPLIER_M
				velocity.y /= BOOST_MULTIPLIER_M
				last_boost_type = ''
			elif last_boost_type == 'S':
				velocity.x /= BOOST_MULTIPLIER_S
				velocity.y /= BOOST_MULTIPLIER_S
				last_boost_type = ''


	# Collsions
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		print_rich("[color=RED][pulse freq=2.5]Collision!!![/pulse][/color]", collision_info,
			"  [color=RED][pulse freq=2.5]ID:[/pulse][/color]", collision_info.get_collider(),
			"  [color=RED][pulse freq=2.5]Layer:[/pulse][/color]",collision_info.get_collider().get_collision_layer()
		)
		
		if collision_info.get_collider().get_collision_layer() == 4:
			# Prey
			collision_info.get_collider().eat_me()
			score += 1
			
		elif collision_info.get_collider().get_collision_layer() == 8:
			# Predator
			bitten()
			velocity = velocity.bounce(collision_info.get_normal())

		else:
			velocity = velocity.bounce(collision_info.get_normal())

	#print_rich("[rainbow freq=1.0 sat=0.8 val=0.8]x[/rainbow]", velocity.x, "[rainbow freq=1.0 sat=0.8 val=0.8]y[/rainbow]", velocity.y)

	# Max Velocity
	velocity = velocity.limit_length(VELOCITY_MAX)
	
	# Echolocation
	var lazor: RayCast2D
	if self.find_child("RayVision").get_class() == "RayCast2D":
		lazor = self.find_child("RayVision")
		#var newLazor: Vector2 = Vector2(1, 13)
		#print_rich("[color=Cyan][pulse freq=2.5]Firin My Lazor[/pulse][/color]", lazor.target_position, "[color=Cyan][pulse freq=2.5]; [/pulse][/color]", lazor.target_position.angle())
		
		
		if player_vision != Vector2(0,0):
			#print(Vector2.from_angle( (player_vision.angle() + velocity.angle())/2 ))
			lazor_rotate(lazor, player_vision)
		else:
			lazor_rotate(lazor, velocity)
		#lazor.target_position = lazor.target_position.rotated(1 * (PI / 180))
	
	# Tail follower
	var my_position = self.global_position
	if my_path.size() > 2:
		var distance = my_position.distance_to(my_path[-1])

	my_path.append(my_position)
	if my_path.size() > 100:
		my_path.remove_at(0)
	
	var follow_dist = FOLLOW_PATH
	var follow_dist2 = FOLLOW_PATH*2
	var follow_size: int = my_path.size()
	if follow_size > FOLLOW_PATH*2 + 10:
		my_torso.global_position.x = my_path[follow_size - follow_dist].x
		my_torso.global_position.y = my_path[follow_size - follow_dist].y
		my_tail.global_position.x = my_path[follow_size - follow_dist2].x
		my_tail.global_position.y = my_path[follow_size - follow_dist2].y




#### x+ right; x- left; y+ down; y- up;
func lazor_rotate(mylazor: RayCast2D, myfocaldirection: Vector2) -> void:
	
	if mylazor.target_position.angle() != myfocaldirection.angle():
		#mylazor.target_position = ECHO_DISTANCE * Vector2.from_angle(myfocaldirection.angle())
		mylazor.target_position = ECHO_DISTANCE * Vector2.from_angle(
				Vector2.from_angle(mylazor.target_position.angle()).move_toward(
					myfocaldirection, 0.05
				).angle()
			)

func bitten() -> void:
	print_rich("[color=MAGENTA][pulse freq=1]Ouch!!![/pulse][/color]")
	my_health -= 1
	if my_health == 3:
		pass
	elif my_health == 2:
		my_life3.visible = false
	elif my_health == 1:
		my_life3.visible = false
		my_life2.visible = false
	elif my_health == 0:
		my_life3.visible = false
		my_life2.visible = false
		my_life1.visible = false
	elif my_health < 0:
		game_over()

func game_over() -> void:
	gameOverGUI.visible = true
	gameOverScore.text = String.num(score)
	gameState = false

func restart() -> void:
	get_tree().reload_current_scene()

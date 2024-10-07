extends RayCast2D

@onready var multimesh = get_parent().multimesh

var echo_scene = load("res://scenes/echo.tscn")
var echo_positions = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.is_colliding():
		#print_rich("[color=RED][pulse freq=2.5]HIT! [/pulse][/color]", self.get_collision_point())
		#print_rich(self.get_parent(), "[color=GREEN];[/color]", self.get_parent().get_parent(), "[color=GREEN];[/color]", self.get_parent().get_parent().get_parent())
		
		var echo_position = self.get_collision_point()
		
		if echo_position:
			echo_positions.append(echo_position)
			multimesh.multimesh.instance_count += 1
			for i in range(multimesh.multimesh.instance_count):
				multimesh.multimesh.set_instance_transform_2d(i, Transform2D().translated(echo_positions[i]))
		
		
		#if self.get_parent().get_parent().find_child("Echos"):
		#	var echos = self.get_parent().get_parent().find_child("Echos")
		#	var echo_instance = echo_scene.instantiate() # Ty Walker!
		#	echo_instance.set_name("echo")
		#	echo_instance.set_global_position(echo_position)
		#	echos.add_child(echo_instance)
		
		# REMOVE THIS SECTION LATER
		#if self.get_parent().get_parent().get_child(-1).get_class() == "Polygon2D":
		#	var pop = self.get_parent().get_parent().get_child(-1)
		#	print(pop.get_global_position())
		#	pop.set_global_position(self.get_collision_point())

extends RayCast2D

var echo_scene = load("res://scenes/echo.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.is_colliding():
		#print_rich("[color=RED][pulse freq=2.5]HIT! [/pulse][/color]", self.get_collision_point())
		#print_rich(self.get_parent(), "[color=GREEN];[/color]", self.get_parent().get_parent(), "[color=GREEN];[/color]", self.get_parent().get_parent().get_parent())
		
		var echo_position = self.get_collision_point()
		
		if self.get_parent().get_parent().find_child("Echos"):
			var echos = self.get_parent().get_parent().find_child("Echos")
			var echo_instance = echo_scene.instantiate() # Ty Walker!
			echo_instance.set_name("echo")
			echo_instance.set_global_position(echo_position)
			echos.add_child(echo_instance)
		
		# REMOVE THIS SECTION LATER
		if self.get_parent().get_parent().get_child(-1).get_class() == "Polygon2D":
			var pop = self.get_parent().get_parent().get_child(-1)
			print(pop.get_global_position())
			pop.set_global_position(self.get_collision_point())
			
			

extends RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.is_colliding():
		print_rich("[color=RED][pulse freq=2.5]HIT! [/pulse][/color]", self.get_collision_point())
		print_rich(self.get_parent(), "[color=GREEN];[/color]", self.get_parent().get_parent(), "[color=GREEN];[/color]", self.get_parent().get_parent().get_parent())
		if self.get_parent().get_parent().get_child(-1).get_class() == "Polygon2D":
			var pop = self.get_parent().get_parent().get_child(-1)
			print(pop.get_global_position())
			pop.set_global_position(self.get_collision_point())
			
			

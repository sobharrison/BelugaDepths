extends Node2D

var prey_scene = load("res://scenes/prey.tscn")
var creatures
const spawn_freq: int = 3000
var prev_spawn: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	creatures = self.get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Time.get_ticks_msec() > prev_spawn + spawn_freq:
		var fresh_meat = prey_scene.instantiate() # Ty Walker!
		#fresh_meat.set_name("Prey2D")
		fresh_meat.set_global_position(self.global_position)
		creatures.add_child(fresh_meat)
		prev_spawn = Time.get_ticks_msec()

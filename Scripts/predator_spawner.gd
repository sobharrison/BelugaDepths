extends Node2D

@export var plan_direction: Vector2 = Vector2(0, 0)
@export var spawn_freq: int = 3000

var predator_scene = load("res://scenes/predator.tscn")
var creatures
var prev_spawn: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	creatures = self.get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Time.get_ticks_msec() > prev_spawn + spawn_freq:
		var hunter = predator_scene.instantiate() # Ty Walker!
		hunter.set_global_position(self.global_position)
		hunter.plan_direction = self.plan_direction
		creatures.add_child(hunter)
		prev_spawn = Time.get_ticks_msec()

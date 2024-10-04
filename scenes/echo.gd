extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.timeout.connect(func(): self.queue_free())
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

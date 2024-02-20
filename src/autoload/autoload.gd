class_name Autoload
extends Node2D

signal gameOver
signal newChallenge

var current_time_target : float = 10.0
var score: int:
	set(value):
		if (value == score):
			return
		current_time_target = maxf(current_time_target - .5, 4.0)

func start_timer() -> SceneTreeTimer:
	return get_tree().create_timer(current_time_target)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

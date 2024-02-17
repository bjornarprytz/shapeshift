extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func check():
	var players = get_tree().get_nodes_in_group("players")
	
	var shapes = get_overlapping_bodies()
	
	# TODO: Make sure all of them are inside the bounds
	
	pass

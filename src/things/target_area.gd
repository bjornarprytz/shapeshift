extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check() -> bool:
	var players = get_tree().get_nodes_in_group("players")
	
	var shapes = get_overlapping_bodies()
	
	return players.all(func(p): return shapes.has(p)) and $NoGoZones.get_children().all(func(z:NoGoZone): return !z.is_touched)

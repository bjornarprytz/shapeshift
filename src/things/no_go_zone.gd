@tool

class_name NoGoZone
extends ReferenceRect

signal onPlayerEntered(player: Player)
signal onPlayerExited(player: Player)

@onready var areaShape : CollisionShape2D = $NoGoZone/Shape


var players_inside: Array[Player] = []

var is_touched: bool:
	set(value):
		if (value == is_touched):
			return
		is_touched = value
		if (!value):
			border_color = Color.GREEN
		else:
			border_color = Color.RED
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resized.connect(_on_resized)
	areaShape.shape = areaShape.shape.duplicate()
	_on_resized()
	is_touched = true
	is_touched = false

func _on_resized():
	(areaShape.shape as RectangleShape2D).size = size
	areaShape.position = size / 2.0

func _on_no_go_zone_area_entered(body: Area2D) -> void:
	if (body.owner is Player):
		players_inside.push_back(body.owner)
		onPlayerEntered.emit(body.owner)
		is_touched = true


func _on_no_go_zone_area_exited(body: Area2D) -> void:
	if (body.owner is Player):
		players_inside.erase(body.owner)
		onPlayerExited.emit(body.owner)
		is_touched = players_inside.size() > 0

class_name Face
extends ColorRect

@onready var look_left_target : Node2D = $LookLeftTarget
@onready var look_right_target : Node2D = $LookRightTarget
@onready var state : StateChart = $StateChart
@onready var eyes : Eyes = $Eyes
@onready var mouth : RichTextLabel = $Mouth

var look_at_target : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func idle():
	look_at_target = null
	state.send_event("idle")

func behold_target(target: Node2D):
	look_at_target = target
	state.send_event("look_at")

func look_left():
	look_at_target = look_left_target
	state.send_event("look_at")
	
func look_right():
	look_at_target = look_right_target
	state.send_event("look_at")

func strain():
	mouth.text = "c"
	state.send_event("strain")
	
func happy():
	mouth.text = ")"
	state.send_event("happy")
	


func _on_look_at_state_physics_processing(delta: float) -> void:
	eyes.look_toward(look_at_target, delta)
	var d = look_at_target.global_position.distance_to(eyes.center.global_position)
	if (d < 100.0):
		eyes.gush(1.0, delta)
	else:
		eyes.reset_lids(delta)


func _on_happy_state_physics_processing(delta: float) -> void:
	pass#eyes.squint(1.0, delta)


func _on_idle_state_physics_processing(delta: float) -> void:
	eyes.reset_lids(delta)
	eyes.look_toward(eyes.center, delta)

class_name Eyes
extends Node2D

const EYE_MOVE_SPEED := 50.0
const EYE_LID_SPEED = 80.0

@export var bounds : Rect2 = Rect2(-10.0, -6.0, 20.0, 12.0)

@onready var left : Node2D = $LeftAnchor
@onready var right : Node2D = $RightAnchor
@onready var center : Node2D =  $Center

@onready var left_lid : ColorRect = $LeftAnchor/Lid
@onready var right_lid : ColorRect = $RightAnchor/Lid

@onready var left_pupil : RichTextLabel = $LeftAnchor/Lid/Pupil
@onready var right_pupil : RichTextLabel = $RightAnchor/Lid/Pupil

@onready var base_pupil_level : float = left_pupil.position.y
@onready var base_lid_level : float = left_lid.position.y
@onready var base_lid_height : float = left_lid.size.y
const lid_move_factor : float = 0.4

@onready var base_left : Vector2 = left.position
@onready var base_right : Vector2 = right.position


func squint(f : float, delta: float):
	relax(f, delta)
	gush(f * 2.0, delta)

func relax(f: float, delta: float):
	var current_level = left_lid.position.y
	var target_level = base_lid_level - (base_lid_level * lid_move_factor * f)
	
	left_lid.position.y = move_toward(current_level, target_level, delta * EYE_LID_SPEED)
	right_lid.position.y = move_toward(current_level, target_level, delta * EYE_LID_SPEED)
	
	left_pupil.position.y = base_pupil_level - (left_lid.position.y - base_lid_level)
	right_pupil.position.y = base_pupil_level - (right_lid.position.y - base_lid_level)
	
func gush(f: float, delta: float):
	var current_height = left_lid.size.y
	var target_height = base_lid_height - (base_lid_height * lid_move_factor * f)
	
	left_lid.size.y = move_toward(current_height, target_height, delta * EYE_LID_SPEED)
	right_lid.size.y = move_toward(current_height, target_height, delta * EYE_LID_SPEED)

func reset_lids(delta: float):
	squint(0.0, delta)

func look_toward(target: Node2D, delta: float):
	var target_relative_position = target.global_position - global_position
	
	var bounded_target = target_relative_position - center.position
	
	bounded_target /= 24.0
	
	bounded_target.x = clamp(bounded_target.x, -10, 10)
	bounded_target.y = clamp(bounded_target.y, -6, 6)
	
	var left_bounded_target = bounded_target + base_left
	var right_bounded_target = bounded_target + base_right
	
	left.position = left.position.move_toward(left_bounded_target, delta * EYE_MOVE_SPEED)
	right.position = right.position.move_toward(right_bounded_target, delta * EYE_MOVE_SPEED)

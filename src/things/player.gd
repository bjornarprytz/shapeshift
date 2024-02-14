extends CharacterBody2D

@export var config : PlayerConfig

@onready var head : ColorRect = $Head
@onready var body : ColorRect = $Body
@onready var head_upright : Node2D = $HeadTopPosition
@onready var head_crouching : Node2D = $HeadLowerPosition
@onready var left_arm : ColorRect = $LeftArm
@onready var right_arm : ColorRect = $RightArm

@onready var eyes : RichTextLabel = $Head/Face/Eyes
@onready var mouth : RichTextLabel = $Head/Face/Mouth

@onready var eyes_base_pos : Vector2 = eyes.position
@onready var mouth_base_pos : Vector2 = mouth.position


const SPEED = 400.0
const JUMP_VELOCITY = -400.0
const BOOST_STRENGTH = 25.0

var boost_time = 300.0
var jump_started: float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_contorting : bool
var confirm_contort : bool

func _ready() -> void:
	assert(config != null)
	for part in [body, head, left_arm, right_arm]:
		part.color = config.color
	

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.keycode == config.contort):
		if (event.is_pressed()):
			is_contorting = true
			if event.is_echo():
				confirm_contort = true
		else:
			if !confirm_contort:
				_release_contortion() # Fast click
			is_contorting = false
			confirm_contort = false
			
	if (is_contorting and event.is_pressed() and !event.is_echo()):
		match (event.keycode):
			config.left:
				_contort_left()
			config.right:
				_contort_right()
			config.up:
				_contort_up()
			config.down:
				_contort_down()

func _contort_left():
	confirm_contort = true
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel()
	tween.tween_property(left_arm, 'rotation_degrees', 90.0, 0.5)
	tween.tween_property(eyes, 'position', eyes_base_pos + (Vector2.LEFT * 5.0), 0.3)
func _contort_right():
	confirm_contort = true
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel()
	tween.tween_property(right_arm, 'rotation_degrees', -90.0, 0.5)
	tween.tween_property(eyes, 'position', eyes_base_pos + (Vector2.RIGHT * 5.0), 0.3)
func _contort_up():
	confirm_contort = true
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel()
	tween.tween_property(left_arm, 'rotation_degrees', 180.0, 0.5)
	tween.tween_property(right_arm, 'rotation_degrees', -180.0, 0.5)
	tween.tween_property(eyes, 'position', eyes_base_pos + (Vector2.UP * 5.0), 0.3)
	tween.tween_callback(func (): mouth.text = "o")
func _contort_down():
	confirm_contort = true
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(head, 'position:y', head_crouching.position.y, 0.5)
	tween.tween_callback(func (): eyes.text = "x")
	tween.tween_callback(func (): mouth.text = ")")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	_handle_move()

	move_and_slide()


func _release_contortion():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC).set_parallel()
	tween.tween_property(left_arm, 'rotation_degrees', 0.0, 0.5)
	tween.tween_property(right_arm, 'rotation_degrees', 0.0, 0.5)
	tween.tween_property(head, 'position:y', head_upright.position.y, 0.5)
	tween.tween_property(eyes, 'position', eyes_base_pos, 0.3)
	tween.tween_callback(func (): eyes.text = ":")
	tween.tween_callback(func (): mouth.text = ")")
	
	
func _handle_move():
	var direction := 0.0
	
	if Input.is_key_pressed(config.right):
		direction += 1.0
	if Input.is_key_pressed(config.left):
		direction -= 1.0
	
	if direction and !is_contorting:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

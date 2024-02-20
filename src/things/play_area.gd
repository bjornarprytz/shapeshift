extends Node2D

@onready var countdown : RichTextLabel = $Countdown
@onready var scoreUi : RichTextLabel = $Score
@onready var targetArea : TargetArea = $TargetArea

var _timer: SceneTreeTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_timer = Global.start_timer()
	_timer.timeout.connect(_check_time)
	Global.gameOver.connect(_game_over)

func _check_time():
	if (!targetArea.check()):
		Global.gameOver.emit()
		_timer = null
	else:
		Global.score += 69 + randi_range(4, 24)
		scoreUi.text = "Score: " + str(Global.score)
		_timer = Global.start_timer()
		_timer.timeout.connect(_check_time)

func _game_over():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($GameOver, 'position', Vector2(477.0, 252.0), 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _timer != null and _timer.time_left >= 0.0:
		countdown.text = str("%.1f" % _timer.time_left)
	else:
		countdown.text = ""

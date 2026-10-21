class_name Chandelier
extends Node2D
## The boudoir chandelier above the mosaic. Three looks: hanging (still),
## swinging (a hit makes it sway around the ceiling hook and settle) and
## fallen (the hanging sprite drops, the wreck with the prism lies on the
## floor). Node origin = the ceiling hook; `hanging` hangs below it.
## Hits and what falls out come with L-4/L-5 (ball, key, crystal prism).
## While nobody touches it, it sways a tiny bit by itself (a draught):
## the strength drifts between gusts, under a degree (bottom moves ~1 px).

signal swung
signal fell

enum State { HANGING, SWINGING, FALLEN }

const SWING_ANGLE: float = 7.0
const SWING_PERIOD: float = 0.9
const SWING_DAMP: float = 0.55
const FALL_TIME: float = 0.45
const IDLE_PERIOD: float = 3.2
const IDLE_MAX: float = 0.9

@export var hanging: Node2D
@export var fallen: Node2D
## World y of the floor where the wreck lies (fallen sprite origin).
@export var floor_y: float = 306.0

var state: State = State.HANGING
## Idle draught sway on/off (tests and screenshots turn it off).
var idle_sway: bool = true
var _tween: Tween
var _idle_t: float = 0.0
var _idle_amp: float = 0.0
var _idle_target: float = 0.0
var _gust_left: float = 0.0


func _ready() -> void:
	if fallen:
		fallen.visible = false


func _process(delta: float) -> void:
	if state != State.HANGING or not idle_sway:
		return
	_gust_left -= delta
	if _gust_left <= 0.0:
		_gust_left = randf_range(3.0, 7.0)
		_idle_target = randf_range(0.0, IDLE_MAX)
	_idle_amp = move_toward(_idle_amp, _idle_target, delta * 0.3)
	_idle_t += delta
	hanging.rotation_degrees = sin(_idle_t * TAU / IDLE_PERIOD) * _idle_amp


## A hit: sway around the hook with a damped swing, then hang still again.
func swing() -> void:
	if state == State.FALLEN:
		return
	state = State.SWINGING
	_idle_amp = 0.0
	swung.emit()
	_kill_tween()
	_tween = create_tween()
	var angle: float = SWING_ANGLE
	for i: int in 4:
		_tween.tween_property(hanging, "rotation_degrees", angle, SWING_PERIOD * 0.5) \
				.set_trans(Tween.TRANS_SINE)
		_tween.tween_property(hanging, "rotation_degrees", -angle * SWING_DAMP, SWING_PERIOD * 0.5) \
				.set_trans(Tween.TRANS_SINE)
		angle *= SWING_DAMP * SWING_DAMP
	_tween.tween_property(hanging, "rotation_degrees", 0.0, SWING_PERIOD * 0.3)
	_tween.tween_callback(func() -> void: state = State.HANGING)


## The last hit: the chandelier drops and lies smashed on the floor.
func fall() -> void:
	if state == State.FALLEN:
		return
	state = State.FALLEN
	_kill_tween()
	_tween = create_tween()
	var drop: float = floor_y - global_position.y - 40.0
	_tween.tween_property(hanging, "position:y", hanging.position.y + drop, FALL_TIME) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_tween.tween_callback(_land)


func _land() -> void:
	hanging.visible = false
	if fallen:
		fallen.visible = true
	fell.emit()


func _kill_tween() -> void:
	if _tween and _tween.is_valid():
		_tween.kill()

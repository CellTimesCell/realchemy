class_name Chandelier
extends Node2D
## The boudoir chandelier above the mosaic. Three looks: hanging (still),
## swinging (a hit makes it sway around the ceiling hook and settle) and
## fallen (the hanging sprite drops, the wreck with the prism lies on the
## floor). Node origin = the ceiling hook; `hanging` hangs below it.
## Hits and what falls out come with L-4/L-5 (ball, key, crystal prism).

signal swung
signal fell

enum State { HANGING, SWINGING, FALLEN }

const SWING_ANGLE: float = 7.0
const SWING_PERIOD: float = 0.9
const SWING_DAMP: float = 0.55
const FALL_TIME: float = 0.45

@export var hanging: Node2D
@export var fallen: Node2D
## World y of the floor where the wreck lies (fallen sprite origin).
@export var floor_y: float = 306.0

var state: State = State.HANGING
var _tween: Tween


func _ready() -> void:
	if fallen:
		fallen.visible = false


## A hit: sway around the hook with a damped swing, then hang still again.
func swing() -> void:
	if state == State.FALLEN:
		return
	state = State.SWINGING
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

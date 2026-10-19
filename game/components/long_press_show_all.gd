class_name LongPressShowAll
extends Node
## Phone: holding a finger still on the screen for HOLD_TIME presses the
## "show_all" action (outline every interactive prop, like Tab on PC) until
## the finger lifts. Moving the finger cancels it (that is a drag/walk).

const HOLD_TIME: float = 0.5
const MOVE_TOLERANCE: float = 12.0

var _touch_index: int = -1
var _start: Vector2 = Vector2.ZERO
var _held: float = 0.0
var _active: bool = false


func _input(event: InputEvent) -> void:
	var touch: InputEventScreenTouch = event as InputEventScreenTouch
	if touch:
		if touch.pressed and _touch_index < 0:
			_touch_index = touch.index
			_start = touch.position
			_held = 0.0
		elif not touch.pressed and touch.index == _touch_index:
			_finish()
		return
	var drag: InputEventScreenDrag = event as InputEventScreenDrag
	if drag and drag.index == _touch_index and not _active and drag.position.distance_to(_start) > MOVE_TOLERANCE:
		_finish()


func _process(delta: float) -> void:
	if _touch_index < 0 or _active:
		return
	_held += delta
	if _held >= HOLD_TIME:
		_active = true
		Input.action_press(&"show_all")


func _finish() -> void:
	if _active:
		Input.action_release(&"show_all")
	_active = false
	_touch_index = -1

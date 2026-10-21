class_name StuckWatcher
extends Node
## The hero thinks aloud when the player is stuck: no puzzle progress for a
## while -> the thought for the current step (data/hints.json). INT makes it
## come sooner (HeroStats effect "thought_delay"). A free hint before the
## ghost grandmother, and between her hints.

## After a thought the next one waits this many times longer.
const REPEAT_FACTOR: float = 1.5

var _elapsed: float = 0.0
var _wait: float = 0.0


func _ready() -> void:
	_reset()
	EventBus.flag_changed.connect(func(flag: String, _value: Variant) -> void:
		if not flag.begins_with("hint_"):
			_reset())
	EventBus.item_found.connect(func(_id: String) -> void: _reset())
	EventBus.puzzle_event.connect(func(_name: String) -> void: _reset())


func _process(delta: float) -> void:
	if EventBus.modal_ui_active:
		return
	_elapsed += delta
	if _elapsed >= _wait:
		think_now()


## Says the thought for the current step (also for tests and screenshots).
func think_now() -> String:
	var key: String = Hints.thought_key()
	_elapsed = 0.0
	_wait = delay() * REPEAT_FACTOR
	if key.is_empty():
		return ""
	EventBus.player_stuck.emit()
	EventBus.hero_line_requested.emit(key)
	return key


func delay() -> float:
	return GameManager.stats.effect("int", "thought_delay")


func _reset() -> void:
	_elapsed = 0.0
	_wait = delay()

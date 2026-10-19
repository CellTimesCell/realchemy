class_name Emote
extends AnimatedSprite2D
## Manpu icon over a character's head ("...", "!", anger vein...). Put it under
## the character's EmoteAnchor marker. show_emote() queues icons: each one pops
## in (rises a few whole pixels), loops its animation for the given time, then
## fades out. Unknown icon names are ignored.
## If `overlay` is set, the icon moves onto that CanvasLayer (above the night
## CanvasModulate, so white stays white) and follows its anchor every frame.

signal emote_finished(emote_name: String)

const RISE_PX: int = 3
const RISE_STEP_TIME: float = 0.03
const FADE_TIME: float = 0.15

@export var default_time: float = 1.4
## Layer drawn above the night tint (follow_viewport_enabled = true).
@export var overlay: CanvasLayer

var _queue: Array[Array] = []
var _busy: bool = false
var _anchor: Node2D
var _rise: int = 0


func _ready() -> void:
	visible = false
	_anchor = get_parent() as Node2D
	if overlay:
		reparent.call_deferred(overlay, false)


func _process(_delta: float) -> void:
	if overlay:
		if not is_instance_valid(_anchor):
			queue_free()
			return
		global_position = _anchor.global_position + Vector2(0, _rise)
	else:
		position.y = _rise


func show_emote(emote_name: String, time: float = -1.0) -> void:
	if sprite_frames == null or not sprite_frames.has_animation(emote_name):
		return
	_queue.append([emote_name, default_time if time < 0.0 else time])
	if not _busy:
		_run_queue()


func clear_queue() -> void:
	_queue.clear()


func _run_queue() -> void:
	_busy = true
	while not _queue.is_empty():
		var item: Array = _queue.pop_front()
		await _show_one(item[0], item[1])
	_busy = false


func _show_one(emote_name: String, time: float) -> void:
	play(emote_name)
	modulate.a = 1.0
	visible = true
	for step: int in RISE_PX + 1:
		_rise = RISE_PX - step
		await get_tree().create_timer(RISE_STEP_TIME).timeout
	await get_tree().create_timer(time).timeout
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, FADE_TIME)
	await tween.finished
	visible = false
	stop()
	emote_finished.emit(emote_name)

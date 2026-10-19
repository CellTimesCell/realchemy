class_name Emote
extends AnimatedSprite2D
## Manpu icon over a character's head ("...", "!", anger vein...). Put it under
## the character's EmoteAnchor marker. show_emote() queues icons: each one pops
## in (rises a few whole pixels), loops its animation for the given time, then
## fades out. Unknown icon names are ignored.

signal emote_finished(emote_name: String)

const RISE_PX: int = 3
const RISE_STEP_TIME: float = 0.03
const FADE_TIME: float = 0.15

@export var default_time: float = 1.4

var _queue: Array[Array] = []
var _busy: bool = false


func _ready() -> void:
	visible = false


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
		position.y = RISE_PX - step
		await get_tree().create_timer(RISE_STEP_TIME).timeout
	await get_tree().create_timer(time).timeout
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, FADE_TIME)
	await tween.finished
	visible = false
	stop()
	emote_finished.emit(emote_name)

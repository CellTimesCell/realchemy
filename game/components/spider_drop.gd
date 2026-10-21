class_name SpiderDrop
extends Node2D
## A tiny spider that now and then lets itself down from a cobweb on its
## thread, dangles a moment and climbs back. Node origin = the web anchor.

@export var spider: Sprite2D
@export var thread: Line2D
@export var drop_min: float = 30.0
@export var drop_max: float = 60.0
@export var climb_time: float = 3.0
@export var interval_min: float = 20.0
@export var interval_max: float = 45.0

var busy: bool = false
var _wait: float = 0.0


func _ready() -> void:
	spider.position = Vector2.ZERO
	spider.visible = false
	_update_thread()
	_wait = randf_range(interval_min, interval_max)


func _process(delta: float) -> void:
	_update_thread()
	if busy:
		return
	_wait -= delta
	if _wait <= 0.0:
		descend()


func descend() -> void:
	if busy:
		return
	busy = true
	spider.visible = true
	var depth: float = roundf(randf_range(drop_min, drop_max))
	var tween: Tween = create_tween()
	tween.tween_property(spider, "position:y", depth, climb_time).set_trans(Tween.TRANS_SINE)
	# Dangles: a pixel down and up, twice.
	for i: int in 2:
		tween.tween_property(spider, "position:y", depth + 1.0, 0.4)
		tween.tween_property(spider, "position:y", depth, 0.4)
	tween.tween_interval(randf_range(1.0, 2.5))
	tween.tween_property(spider, "position:y", 0.0, climb_time).set_trans(Tween.TRANS_SINE)
	await tween.finished
	spider.visible = false
	busy = false
	_wait = randf_range(interval_min, interval_max)


func _update_thread() -> void:
	thread.visible = spider.visible
	thread.points = PackedVector2Array([Vector2.ZERO, Vector2(0.0, roundf(spider.position.y) - 3.0)])

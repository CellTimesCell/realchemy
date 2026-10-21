class_name ProcessBadge
extends Node2D
## A small plate over the thing a real-time process works on (the gate
## lock): "Rust soaking 43%  12:05" while it runs, then "The rust is soft!"
## for a while. The label lives on the "above_night" layer like prompts.

const DONE_SHOW_TIME: float = 6.0
const REFRESH: float = 0.25

@export var process_id: String = "rust_lock"
@export var running_key: String = "UI_RUST_SOAKING"
@export var done_key: String = "UI_RUST_SOFT"

var label: Label
var _refresh_left: float = 0.0
var _done_left: float = 0.0


func _ready() -> void:
	label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UiStyle.style_prompt(label)
	label.visible = false
	var layer: Node = get_tree().get_first_node_in_group(&"above_night")
	if layer:
		layer.add_child.call_deferred(label)
	else:
		add_child(label)
	EventBus.process_finished.connect(func(id: String) -> void:
		if id == process_id:
			_done_left = DONE_SHOW_TIME)


func _exit_tree() -> void:
	if is_instance_valid(label):
		label.queue_free()


func _process(delta: float) -> void:
	_refresh_left -= delta
	_done_left = maxf(0.0, _done_left - delta)
	if _refresh_left > 0.0:
		return
	_refresh_left = REFRESH
	if TimeManager.is_running(process_id):
		var left: int = TimeManager.remaining(process_id)
		label.text = "%s %d%%  %d:%02d" % [tr(running_key), int(TimeManager.progress(process_id) * 100.0), left / 60, left % 60]
		label.visible = true
	elif _done_left > 0.0:
		label.text = tr(done_key)
		label.visible = true
	else:
		label.visible = false
	if label.visible:
		label.reset_size()
		label.position = (global_position - Vector2(label.size.x * 0.5, label.size.y)).round()

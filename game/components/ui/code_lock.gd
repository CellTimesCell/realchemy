class_name CodeLock
extends PanelContainer
## The 4-wheel combination lock (the princess's chest): up / down per wheel,
## Open checks the code from data/interactables.json. Right -> the prop's
## unlock flag + puzzle_event "unlocked_<id>"; wrong -> the hero's line.

signal finished(opened: bool)

const WHEELS: int = 4

var target_id: String = ""
var code: String = ""
var digits: Array[int] = [0, 0, 0, 0]
var _labels: Array[Label] = []


func _ready() -> void:
	visible = false
	var box: StyleBoxFlat = StyleBoxFlat.new()
	box.bg_color = Color(0.12, 0.08, 0.05, 0.96)
	box.border_color = Color(0.85, 0.7, 0.4)
	box.set_border_width_all(1)
	box.set_content_margin_all(6)
	add_theme_stylebox_override("panel", box)
	var column: VBoxContainer = VBoxContainer.new()
	column.add_theme_constant_override("separation", 4)
	add_child(column)
	column.add_child(Hud.make_label("UI_CODE_LOCK"))
	var row: HBoxContainer = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 6)
	column.add_child(row)
	for i: int in WHEELS:
		var wheel: VBoxContainer = VBoxContainer.new()
		wheel.add_child(Hud.make_button("+", turn.bind(i, 1)))
		var digit: Label = Hud.make_label("0")
		digit.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		digit.auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED
		digit.add_theme_font_size_override("font_size", 16)
		wheel.add_child(digit)
		wheel.add_child(Hud.make_button("-", turn.bind(i, -1)))
		row.add_child(wheel)
		_labels.append(digit)
	var buttons: HBoxContainer = HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_child(Hud.make_button("UI_OPEN_LOCK", func() -> void: try_open()))
	buttons.add_child(Hud.make_button("UI_CANCEL", func() -> void: close(false)))
	column.add_child(buttons)
	EventBus.code_lock_requested.connect(open)


func open(for_target: String, combination: String) -> void:
	target_id = for_target
	code = combination
	digits = [0, 0, 0, 0]
	_refresh()
	visible = true
	EventBus.set_modal_ui(true)
	size = Vector2.ZERO
	reset_size()
	var view: Vector2 = get_viewport().get_visible_rect().size
	position = ((view - size) * 0.5).floor()


## Turns a wheel one notch (wraps 9 -> 0).
func turn(wheel: int, step: int) -> void:
	digits[wheel] = posmod(digits[wheel] + step, 10)
	AudioManager.play_sfx("creak", 2.0)
	_refresh()


func entered() -> String:
	var text_value: String = ""
	for d: int in digits:
		text_value += str(d)
	return text_value


func try_open() -> bool:
	if entered() != code:
		EventBus.hero_line_requested.emit("SAY_CODE_WRONG")
		EventBus.repeated_mistakes.emit()
		return false
	var config: Dictionary = Interactable.load_table().get(target_id, {})
	GameManager.set_flag(config.get("unlock_flag", "unlocked_%s" % target_id))
	GameManager.add_xp("wit", 10)
	close(true)
	EventBus.puzzle_event.emit("unlocked_%s" % target_id)
	return true


func close(opened: bool) -> void:
	visible = false
	EventBus.set_modal_ui(false)
	finished.emit(opened)


func _refresh() -> void:
	for i: int in WHEELS:
		_labels[i].text = str(digits[i])

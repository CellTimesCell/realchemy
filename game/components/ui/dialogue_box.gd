class_name DialogueBox
extends PanelContainer
## A short scripted dialogue (data/dialogues.json): one line at a time with
## the speaker ("Grandma:" in green, "Me:" in white), Next / ui_accept to go
## on. Modal while open; EventBus.dialogue_finished at the end.

const PATH: String = "res://data/dialogues.json"
const COLORS: Dictionary = {"ghost": Color(0.75, 1, 0.8), "hero": Color(0.95, 0.92, 0.98)}
const NAMES: Dictionary = {"ghost": "UI_GRANDMA", "hero": "UI_HERO"}

var dialogue_id: String = ""
var lines: Array = []
var index: int = 0
var _label: Label
var _box: StyleBoxFlat


func _ready() -> void:
	visible = false
	_box = StyleBoxFlat.new()
	_box.bg_color = Color(0.05, 0.04, 0.08, 0.94)
	_box.set_border_width_all(1)
	_box.set_content_margin_all(6)
	add_theme_stylebox_override("panel", _box)
	var column: VBoxContainer = VBoxContainer.new()
	add_child(column)
	_label = Hud.make_label("")
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label.custom_minimum_size = Vector2(300, 0)
	column.add_child(_label)
	var next: Button = Hud.make_button("UI_NEXT", advance)
	next.size_flags_horizontal = Control.SIZE_SHRINK_END
	column.add_child(next)
	EventBus.dialogue_requested.connect(play)


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		advance()


func play(id: String) -> void:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
	lines = parsed.get(id, []) if parsed is Dictionary else []
	if lines.is_empty():
		return
	dialogue_id = id
	index = 0
	visible = true
	EventBus.set_modal_ui(true)
	_show()


func advance() -> void:
	index += 1
	if index >= lines.size():
		visible = false
		EventBus.set_modal_ui(false)
		EventBus.dialogue_finished.emit(dialogue_id)
		return
	_show()


func _show() -> void:
	var line: Dictionary = lines[index]
	var speaker: String = line.get("speaker", "hero")
	_label.text = "%s %s" % [tr(NAMES.get(speaker, "UI_HERO")), tr(line.get("key", ""))]
	_label.add_theme_color_override("font_color", COLORS.get(speaker, Color.WHITE))
	_box.border_color = Color(0.55, 1, 0.65) if speaker == "ghost" else Color(0.75, 0.65, 0.85)
	size = Vector2.ZERO
	reset_size()
	var view: Vector2 = get_viewport().get_visible_rect().size
	position = Vector2(floorf((view.x - size.x) * 0.5), 8)

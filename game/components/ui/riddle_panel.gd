class_name RiddlePanel
extends PanelContainer
## The ghost's riddles (data/riddles.json), in order: the question and three
## answers. Wrong -> her grumble, try again (no penalty); right -> the reward
## item, riddle_<id>_solved, her "Clever." After the third: her goodbye.

const PATH: String = "res://data/riddles.json"

var data: Dictionary = {}
var current: Dictionary = {}
var _question: Label
var _answers: VBoxContainer


func _ready() -> void:
	visible = false
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
	data = parsed if parsed is Dictionary else {}
	var box: StyleBoxFlat = StyleBoxFlat.new()
	box.bg_color = Color(0.04, 0.09, 0.06, 0.95)
	box.border_color = Color(0.55, 1, 0.65)
	box.set_border_width_all(1)
	box.set_content_margin_all(6)
	add_theme_stylebox_override("panel", box)
	var column: VBoxContainer = VBoxContainer.new()
	column.add_theme_constant_override("separation", 4)
	add_child(column)
	_question = Hud.make_label("")
	_question.add_theme_color_override("font_color", Color(0.75, 1, 0.8))
	_question.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_question.custom_minimum_size = Vector2(280, 0)
	column.add_child(_question)
	_answers = VBoxContainer.new()
	column.add_child(_answers)
	EventBus.riddle_requested.connect(ask_next)


## The first unsolved riddle, or {} when all are solved.
func next_riddle() -> Dictionary:
	for riddle: Dictionary in data.get("riddles", []):
		if not GameManager.has_flag("riddle_%s_solved" % riddle["id"]):
			return riddle
	return {}


func ask_next() -> void:
	current = next_riddle()
	if current.is_empty():
		EventBus.ghost_line_requested.emit(data.get("done_line_key", ""))
		EventBus.riddle_closed.emit()
		return
	_question.text = "%s %s" % [tr("UI_GRANDMA"), tr(current["question_key"])]
	for child: Node in _answers.get_children():
		_answers.remove_child(child)
		child.queue_free()
	for option: String in current["options"]:
		_answers.add_child(Hud.make_button(_option_text(option), func() -> void: answer(option)))
	_answers.add_child(Hud.make_button("UI_CANCEL", close))
	visible = true
	EventBus.set_modal_ui(true)
	size = Vector2.ZERO
	reset_size()
	var view: Vector2 = get_viewport().get_visible_rect().size
	position = Vector2(floorf((view.x - size.x) * 0.5), 8)


func answer(option: String) -> bool:
	if current.is_empty():
		return false
	if option != current["answer"]:
		EventBus.ghost_line_requested.emit(current.get("grumble_key", ""))
		EventBus.player_blunder.emit()
		return false
	GameManager.set_flag("riddle_%s_solved" % current["id"])
	GameManager.give_item(current["reward"])
	GameManager.add_xp("int", 10)
	EventBus.ghost_line_requested.emit(data.get("right_line_key", ""))
	close()
	return true


func close() -> void:
	visible = false
	EventBus.set_modal_ui(false)
	EventBus.riddle_closed.emit()


func _option_text(option: String) -> String:
	var key: String = data.get("option_keys", {}).get(option, "")
	return tr(key) if not key.is_empty() else tr(ItemDb.name_key(option))

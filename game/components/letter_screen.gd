class_name LetterScreen
extends CanvasLayer
## Full-screen reader for letters and notes: dimmed backdrop, parchment, text
## from a localization key. Text that does not fit the label is split into
## pages: ui_accept or a click turns the page (and closes after the last one),
## Esc closes at once. While open, the rest of the game is blocked via EventBus.

signal closed

const ARROW_BLINK_MS: int = 400

@export var text_label: Label
## Shown while there is a next page.
@export var next_arrow: CanvasItem

var _page: int = 0
var _page_count: int = 1
var _lines_per_page: int = 1
## Label height from the layout; the label itself grows to fit its text.
var _page_height: float = 0.0


func show_letter(text_key: String) -> void:
	var spacing: int = text_label.get_theme_constant("line_spacing")
	var line_height: int = text_label.get_line_height() + spacing
	_lines_per_page = maxi(1, int((_page_height + spacing) / line_height))
	_page_count = 1
	text_label.text = text_key
	_show_page(0)
	visible = true
	EventBus.set_modal_ui(true)
	# The label wraps its text on the next frame; only then is the line count known.
	await get_tree().process_frame
	_page_count = maxi(1, ceili(float(text_label.get_line_count()) / _lines_per_page))
	_show_page(_page)


func _ready() -> void:
	visible = false
	_page_height = text_label.size.y


func _process(_delta: float) -> void:
	if visible and next_arrow and next_arrow.visible:
		next_arrow.modulate.a = 1.0 if Time.get_ticks_msec() % (ARROW_BLINK_MS * 2) < ARROW_BLINK_MS else 0.4


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	var click: InputEventMouseButton = event as InputEventMouseButton
	if event.is_action_pressed("ui_cancel"):
		_close()
	elif event.is_action_pressed("ui_accept") or (click and click.pressed and click.button_index == MOUSE_BUTTON_LEFT):
		if _page + 1 < _page_count:
			_show_page(_page + 1)
		else:
			_close()
	else:
		return
	get_viewport().set_input_as_handled()


func _show_page(page: int) -> void:
	_page = page
	text_label.lines_skipped = page * _lines_per_page
	text_label.max_lines_visible = _lines_per_page
	if next_arrow:
		next_arrow.visible = page + 1 < _page_count


func _close() -> void:
	visible = false
	EventBus.set_modal_ui(false)
	closed.emit()

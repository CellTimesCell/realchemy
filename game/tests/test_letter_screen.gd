extends GutTest
## Letter screen: long text is paginated, and the modal flag blocks the rest
## of the UI until the letter is closed.

const LONG_TEXT: String = "Line of letter text. More words to fill the page and then some more. "

var _screen: LetterScreen
var _arrow: Polygon2D


func before_each() -> void:
	_screen = LetterScreen.new()
	var label: Label = Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size = Vector2(180, 132)
	_arrow = Polygon2D.new()
	_screen.add_child(label)
	_screen.add_child(_arrow)
	_screen.text_label = label
	_screen.next_arrow = _arrow
	add_child_autofree(_screen)


func after_each() -> void:
	EventBus.set_modal_ui(false)


func _accept() -> void:
	var event: InputEventAction = InputEventAction.new()
	event.action = "ui_accept"
	event.pressed = true
	_screen._unhandled_input(event)


func test_long_text_is_split_into_pages() -> void:
	await _screen.show_letter(LONG_TEXT.repeat(12))
	assert_true(EventBus.modal_ui_active, "Opening a letter blocks the UI")
	assert_true(_arrow.visible, "Next arrow shows while pages remain")
	var first_skip: int = _screen.text_label.lines_skipped
	_accept()
	assert_true(_screen.visible, "Accept turns the page instead of closing")
	assert_gt(_screen.text_label.lines_skipped, first_skip, "Second page skips the first page's lines")


func test_short_text_closes_on_accept() -> void:
	await _screen.show_letter("Short note.")
	assert_false(_arrow.visible, "No arrow for a single page")
	_accept()
	assert_false(_screen.visible, "Accept on the last page closes the letter")
	assert_false(EventBus.modal_ui_active, "Closing unblocks the UI")

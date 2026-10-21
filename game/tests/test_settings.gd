extends GutTest
## Text size setting (SaveManager -> UiStyle) and the phone long press that
## shows every interactive prop.

var _saved: String


func before_each() -> void:
	_saved = SaveManager.get_text_size()


func after_each() -> void:
	SaveManager.set_text_size(_saved)
	Input.action_release(&"show_all")


func test_default_text_size_is_small_on_pc() -> void:
	assert_eq(SaveManager.default_text_size(), "small", "PC (tests run on Windows) defaults to Small")


func test_text_size_switches_ui_variant() -> void:
	UiStyle.window_size = Vector2i(1920, 1080)
	watch_signals(EventBus)
	SaveManager.set_text_size("large")
	assert_eq(UiStyle.get_variant(), "A", "Large = variant A")
	SaveManager.set_text_size("small")
	assert_eq(UiStyle.get_variant(), "B", "Small = variant B")
	assert_signal_emitted(EventBus, "settings_changed")
	assert_lt(UiStyle.bubble_max_width() * UiStyle.text_scale(), 640.0 * 0.45, "Bubble stays under 45% of the screen")


func test_small_text_is_large_on_a_small_window() -> void:
	SaveManager.set_text_size("small")
	UiStyle.window_size = Vector2i(640, 360)
	assert_eq(UiStyle.get_variant(), "A", "Half-scale text is mush under 1280x720")
	UiStyle.window_size = Vector2i(1280, 720)
	assert_eq(UiStyle.get_variant(), "B")
	UiStyle.window_size = Vector2i(1920, 1080)


func test_long_press_shows_all() -> void:
	var press: LongPressShowAll = LongPressShowAll.new()
	add_child_autofree(press)
	var touch: InputEventScreenTouch = InputEventScreenTouch.new()
	touch.pressed = true
	touch.position = Vector2(100, 100)
	press._input(touch)
	press._process(LongPressShowAll.HOLD_TIME + 0.1)
	assert_true(Input.is_action_pressed(&"show_all"), "Held finger shows all")
	touch.pressed = false
	press._input(touch)
	assert_false(Input.is_action_pressed(&"show_all"), "Lifting the finger hides it")


func test_moving_finger_cancels_long_press() -> void:
	var press: LongPressShowAll = LongPressShowAll.new()
	add_child_autofree(press)
	var touch: InputEventScreenTouch = InputEventScreenTouch.new()
	touch.pressed = true
	press._input(touch)
	var drag: InputEventScreenDrag = InputEventScreenDrag.new()
	drag.position = Vector2(40, 0)
	press._input(drag)
	press._process(LongPressShowAll.HOLD_TIME + 0.1)
	assert_false(Input.is_action_pressed(&"show_all"), "A drag is not a long press")

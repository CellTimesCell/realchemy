extends GutTest
## Boudoir chandelier: a hit swings it and it settles back to hanging; the
## last hit drops it and swaps to the fallen wreck. Plus batch 10 strings.

const STRINGS: String = "res://data/i18n/strings.csv"


func _make_chandelier() -> Chandelier:
	var chandelier: Chandelier = Chandelier.new()
	chandelier.hanging = Node2D.new()
	chandelier.add_child(chandelier.hanging)
	chandelier.fallen = Node2D.new()
	add_child_autofree(chandelier.fallen)
	chandelier.floor_y = 120.0
	add_child_autofree(chandelier)
	return chandelier


func test_fallen_hidden_at_start() -> void:
	var chandelier: Chandelier = _make_chandelier()
	assert_false(chandelier.fallen.visible)
	assert_eq(chandelier.state, Chandelier.State.HANGING)


func test_swing_settles_back() -> void:
	var chandelier: Chandelier = _make_chandelier()
	watch_signals(chandelier)
	chandelier.swing()
	assert_eq(chandelier.state, Chandelier.State.SWINGING)
	assert_signal_emitted(chandelier, "swung")
	await wait_seconds(Chandelier.SWING_PERIOD * 4.5)
	assert_eq(chandelier.state, Chandelier.State.HANGING)
	assert_almost_eq(chandelier.hanging.rotation_degrees, 0.0, 0.01)


func test_fall_shows_wreck() -> void:
	var chandelier: Chandelier = _make_chandelier()
	watch_signals(chandelier)
	chandelier.fall()
	await wait_seconds(Chandelier.FALL_TIME + 0.2)
	assert_eq(chandelier.state, Chandelier.State.FALLEN)
	assert_false(chandelier.hanging.visible)
	assert_true(chandelier.fallen.visible)
	assert_signal_emitted(chandelier, "fell")
	chandelier.swing()
	assert_eq(chandelier.state, Chandelier.State.FALLEN, "No swinging once fallen")


func test_batch10_lines_exist() -> void:
	var text: String = FileAccess.get_file_as_string(STRINGS)
	for key: String in ["SAY_TROPHY_GRIFFIN", "SAY_TROPHY_UNICORN", "SAY_TROPHY_DRAGON",
			"UI_REACH_IN", "SAY_DRAGON_COIN", "SAY_BALL", "SAY_CHANDELIER"]:
		assert_true(text.contains("\n" + key + ","), key)


func test_dragon_head_holds_a_coin() -> void:
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/interactables.json"))
	var dragon: Dictionary = data["trophy_dragon"]
	assert_eq(dragon["pose"], "interact_high")
	assert_eq(dragon["item"]["id"], "coin")
	assert_eq(dragon["line_key"], "SAY_DRAGON_COIN")

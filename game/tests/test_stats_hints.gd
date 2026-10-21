extends GutTest
## L-2: the guild card stats, xp and levels, stat effects (never blocking),
## the hero's thoughts when stuck (INT), the ghost's hint levels and cooldown,
## pushing the chair (STR).


func before_each() -> void:
	GameManager.reset()
	GameManager.mode = "classic"


func test_start_stats_in_range() -> void:
	var stats: HeroStats = HeroStats.new()
	for stat: String in HeroStats.order():
		assert_between(stats.value(stat), 1, 3, stat)
	assert_eq(HeroStats.rank(), "F")


func test_xp_levels_up() -> void:
	var stats: HeroStats = HeroStats.new()
	var before: int = stats.value("str")
	assert_false(stats.add_xp("str", 5))
	assert_true(stats.add_xp("str", 5), "10 xp = level 1")
	assert_eq(stats.value("str"), before + 1)
	assert_false(stats.add_xp("nonsense", 50))


func test_effects_shorten_but_never_vanish() -> void:
	var stats: HeroStats = HeroStats.new()
	var slow: float = stats.effect("str", "push_time")
	stats.add_xp("str", 1000)
	var fast: float = stats.effect("str", "push_time")
	assert_lt(fast, slow, "More STR, faster push")
	assert_gte(fast, 0.8, "Clamped by min")
	assert_lt(stats.effect("int", "thought_delay") , 75.0)


func test_current_step_follows_flags() -> void:
	assert_eq(Hints.current_step()["id"], "chair")
	GameManager.set_flag("chair_under_tree")
	assert_eq(Hints.current_step()["id"], "orange")
	GameManager.give_item("orange")
	assert_eq(Hints.current_step()["id"], "juice")
	GameManager.give_item("orange_juice")
	assert_eq(Hints.current_step()["id"], "lock")
	GameManager.set_flag("lock_juiced")
	assert_eq(Hints.current_step()["id"], "chandelier", "While the rust soaks: the backpack branch")
	GameManager.set_flag("lock_rust_gone")
	assert_eq(Hints.current_step()["id"], "pick")


func test_hint_levels_and_cooldown() -> void:
	var first: Dictionary = Hints.next_hint(1000.0)
	assert_eq(first["key"], "HINT_CHAIR_1")
	var too_soon: Dictionary = Hints.next_hint(1010.0)
	assert_eq(too_soon["level"], -1, "Cooldown")
	assert_eq(Hints.next_hint(1100.0)["key"], "HINT_CHAIR_2")
	assert_eq(Hints.next_hint(1200.0)["key"], "HINT_CHAIR_3")
	assert_eq(Hints.next_hint(1300.0)["key"], "HINT_CHAIR_3", "Stays at level 3")


func test_crown_needs_the_ghost() -> void:
	var giver: HintGiver = HintGiver.new()
	add_child_autofree(giver)
	assert_eq(giver.give(), "", "Before she is met: nothing")
	GameManager.set_flag("ghost_met")
	watch_signals(EventBus)
	assert_eq(giver.give(), "HINT_CHAIR_1")
	assert_signal_emitted(EventBus, "ghost_line_requested")


func test_stuck_hero_thinks_aloud() -> void:
	var watcher: StuckWatcher = StuckWatcher.new()
	add_child_autofree(watcher)
	watch_signals(EventBus)
	watcher._process(watcher.delay() + 0.1)
	assert_signal_emitted_with_parameters(EventBus, "hero_line_requested", ["THINK_ORANGES_HIGH"])
	assert_signal_emitted(EventBus, "player_stuck")


func test_more_int_thinks_sooner() -> void:
	var slow: float = GameManager.stats.effect("int", "thought_delay")
	GameManager.stats.add_xp("int", 1000)
	assert_lt(GameManager.stats.effect("int", "thought_delay"), slow)


func test_every_hint_and_thought_has_a_string() -> void:
	var text: String = FileAccess.get_file_as_string("res://data/i18n/strings.csv")
	for step: Dictionary in Hints.data()["steps"]:
		assert_true(text.contains("\n" + step["thought_key"] + ","), step["thought_key"])
		for key: String in step["hints"]:
			assert_true(text.contains("\n" + key + ","), key)


func test_push_chair() -> void:
	var chair: PushProp = PushProp.new()
	chair.hotspot = Hotspot.new()
	chair.add_child(chair.hotspot)
	chair.target = Vector2(100, 0)
	var bear: Node2D = Node2D.new()
	add_child_autofree(bear)
	chair.riders = [bear]
	add_child_autofree(chair)
	await chair.push()
	assert_eq(chair.global_position, Vector2(100, 0))
	assert_eq(bear.global_position, Vector2(100, 0), "The bear rides along")
	assert_true(GameManager.has_flag("chair_under_tree"))

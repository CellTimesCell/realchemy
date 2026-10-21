extends GutTest
## Ambient life: the bats fly a pass and scatter unharmed, the portrait blinks
## and yawns (and remembers the yawn for the next look), the mouse runs into
## its crack, the wardrobe glimmer stops once the wardrobe is opened.


func _sprite(frames: int) -> Sprite2D:
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = PlaceholderTexture2D.new()
	sprite.hframes = frames
	return sprite


func test_bats_fly_and_scatter() -> void:
	var flock: BatFlock = BatFlock.new()
	flock.texture = PlaceholderTexture2D.new()
	flock.interactive = true
	flock.interval_min = 999.0
	flock.interval_max = 999.0
	add_child_autofree(flock)
	watch_signals(flock)
	flock.fly()
	flock._process(0.5)
	assert_true(flock.flying)
	await flock.scatter()
	assert_signal_emitted(flock, "scattered")
	assert_false(flock.flying, "Gone after scattering")


func test_bats_pass_ends_off_screen() -> void:
	var flock: BatFlock = BatFlock.new()
	flock.texture = PlaceholderTexture2D.new()
	flock.x_from = 0.0
	flock.x_to = 100.0
	flock.speed = 200.0
	flock.interval_min = 999.0
	flock.interval_max = 999.0
	add_child_autofree(flock)
	flock.fly()
	for i: int in 40:
		flock._process(0.1)
	assert_false(flock.flying, "The pass is over once every bat has left the room")


func test_portrait_yawn_is_remembered() -> void:
	var portrait: CountPortrait = CountPortrait.new()
	portrait.eyes = _sprite(1)
	portrait.lids = _sprite(2)
	portrait.yawn_overlay = _sprite(3)
	portrait.hotspot = Hotspot.new()
	portrait.hotspot.say_key = "SAY_PAINTING_COUNT"
	for child: Node in [portrait.eyes, portrait.lids, portrait.yawn_overlay, portrait.hotspot]:
		portrait.add_child(child)
	add_child_autofree(portrait)
	assert_false(portrait.lids.visible)
	portrait.yawn()
	assert_true(portrait.yawning)
	assert_false(portrait.eyes.visible, "Eyes hide while he yawns")
	await wait_until(func() -> bool: return not portrait.yawning, 5.0)
	assert_true(portrait.eyes.visible)
	assert_eq(portrait.hotspot.say_key, "SAY_PORTRAIT_YAWN")


func test_mouse_runs_into_the_crack() -> void:
	var mouse: CritterRun = CritterRun.new()
	mouse.texture = PlaceholderTexture2D.new()
	mouse.hframes = 4
	mouse.distance = -50.0
	mouse.speed = 100.0
	mouse.interval_min = 999.0
	mouse.interval_max = 999.0
	add_child_autofree(mouse)
	mouse.run()
	assert_true(mouse.visible)
	for i: int in 10:
		mouse._process(0.1)
	assert_false(mouse.running)
	assert_false(mouse.visible, "Hidden in the crack")


func test_ambient_lines_exist() -> void:
	var text: String = FileAccess.get_file_as_string("res://data/i18n/strings.csv")
	for key: String in ["SAY_BATS_MISSED", "SAY_MOUSE", "SAY_PORTRAIT_YAWN"]:
		assert_true(text.contains("\n" + key + ","), key)

extends GutTest
## Princess study and music corner: the lab table close-up loads its data, the
## gramophone plays a tune and reports it on EventBus, the canary sings along
## while it plays, and the new lines exist in the string table.

const LAB_VIEW: String = "res://scenes/first_person/lab_table_view.tscn"
const STRINGS: String = "res://data/i18n/strings.csv"


func _make_gramophone() -> Gramophone:
	var gramophone: Gramophone = Gramophone.new()
	gramophone.hotspot = Hotspot.new()
	gramophone.add_child(gramophone.hotspot)
	gramophone.player = AudioStreamPlayer2D.new()
	gramophone.add_child(gramophone.player)
	gramophone.sprite = Sprite2D.new()
	gramophone.add_child(gramophone.sprite)
	var note: AudioStreamWAV = AudioStreamWAV.new()
	gramophone.notes = [note]
	add_child_autofree(gramophone)
	return gramophone


func test_lab_table_view_loads() -> void:
	var view: FirstPersonView = (load(LAB_VIEW) as PackedScene).instantiate() as FirstPersonView
	add_child_autofree(view)
	assert_eq(view.data.get("id"), "lab_table")
	assert_eq(view.data.get("enter_line_key"), "SAY_LAB_TABLE")
	assert_gt((view.data["hotspots"] as Array).size(), 0)


func test_gramophone_reports_start_and_stop() -> void:
	var gramophone: Gramophone = _make_gramophone()
	watch_signals(EventBus)
	gramophone.play_tune()
	assert_true(gramophone.playing)
	assert_signal_emitted_with_parameters(EventBus, "music_played", [true])
	await wait_seconds(Gramophone.NOTE_GAP * Gramophone.TUNE.size() + 0.3)
	assert_false(gramophone.playing)
	assert_signal_emitted_with_parameters(EventBus, "music_played", [false])
	assert_eq(gramophone.sprite.position, Vector2.ZERO, "Sprite back in place")


func test_canary_sings_while_music_plays() -> void:
	var canary: Canary = Canary.new()
	canary.sprite_frames = SpriteFrames.new()
	for anim: String in ["sit", "preen", "alarm"]:
		canary.sprite_frames.add_animation(anim)
	add_child_autofree(canary)
	EventBus.music_played.emit(true)
	assert_true(canary.singing)
	EventBus.music_played.emit(false)
	assert_false(canary.singing)


func test_new_lines_exist() -> void:
	var text: String = FileAccess.get_file_as_string(STRINGS)
	for key: String in ["UI_USE", "UI_LOOK", "UI_WIND_UP", "SAY_BOOKCASE", "SAY_TELESCOPE",
			"SAY_LAB_TABLE", "SAY_RECORDS", "SAY_GRAMOPHONE", "SAY_GLOBE"]:
		assert_true(text.contains("\n" + key + ","), key)

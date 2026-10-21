extends GutTest
## L-3: the whole game state survives save -> load: room, hero position,
## hands and pockets, stats, flags, Codex, real-time processes (Unix
## timestamps, finishing while the game was closed) and prop states.

const SUITE: String = "res://scenes/rooms/princess_suite.tscn"
const TEST_SAVE: String = "user://test_save.json"


func before_each() -> void:
	SaveManager.load_on_start = false
	SaveManager.save_path = TEST_SAVE
	SaveManager.delete_save()
	GameManager.reset()
	TimeManager.clear()


func after_all() -> void:
	SaveManager.delete_save()
	SaveManager.save_path = SaveManager.SAVE_PATH
	SaveManager.load_on_start = true
	GameManager.reset()
	TimeManager.clear()


func _suite() -> Node:
	var scene: Node = (load(SUITE) as PackedScene).instantiate()
	add_child_autofree(scene)
	return scene


func test_round_trip_game_state() -> void:
	var scene: Node = _suite()
	GameManager.give_item("orange", 2)
	GameManager.give_item("key")
	GameManager.equip("key", 1)
	GameManager.give_item("backpack")
	GameManager.set_flag("chair_under_tree")
	GameManager.add_xp("dex", 12)
	GameManager.unlock_codex("citric_acid")
	GameManager.mode = "cozy"
	(scene.get("hero") as Node2D).global_position = Vector2(900, 320)
	(scene.get_node("Props/Nightstand") as Interactable).load_state({"open": true, "items_left": 0})
	assert_true(SaveManager.save_game())
	scene.free()
	GameManager.reset()
	GameManager.mode = "classic"
	var again: Node = _suite()
	assert_true(SaveManager.load_game())
	assert_eq(GameManager.mode, "cozy")
	assert_eq(GameManager.inventory.count_of("orange"), 2)
	assert_eq(GameManager.inventory.held(Inventory.Hand.RIGHT), "key")
	assert_eq(GameManager.inventory.capacity, 36)
	assert_true(GameManager.has_flag("chair_under_tree"))
	assert_eq(GameManager.stats.level("dex"), 1)
	assert_eq(GameManager.codex, ["citric_acid"] as Array[String])
	assert_eq((again.get("hero") as Node2D).global_position, Vector2(900, 320))
	assert_true((again.get_node("Props/Nightstand") as Interactable).is_open, "Prop state restored")
	assert_eq((again.get_node("Props/XChair") as Node2D).global_position, Vector2(1208, 296), "The chair stays under the tree")


func test_process_finishes_while_closed() -> void:
	_suite()
	GameManager.mode = "classic"
	TimeManager.start_reaction("rust_dissolving", "rust_lock", "orange_juice")
	assert_true(TimeManager.is_running("rust_lock"))
	assert_eq(TimeManager.remaining("rust_lock"), 900)
	SaveManager.save_game()
	TimeManager.clear()
	GameManager.reset()
	# The player comes back a quarter of an hour later.
	TimeManager.clock_offset = 901.0
	SaveManager.load_game()
	assert_true(TimeManager.is_done("rust_lock"))
	assert_true(GameManager.has_flag("lock_rust_gone"))


func test_salted_juice_halves_the_wait() -> void:
	assert_eq(ChemistryEngine.duration_for("rust_dissolving", "classic", "salted_juice"), 450)
	assert_eq(ChemistryEngine.duration_for("rust_dissolving", "cozy", "orange_juice"), 120)
	assert_eq(ChemistryEngine.duration_for("rust_dissolving", "real", "orange_juice"), 7200)


func test_save_file_is_json_with_unix_times() -> void:
	_suite()
	TimeManager.start_reaction("rust_dissolving", "rust_lock", "orange_juice")
	SaveManager.save_game()
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(TEST_SAVE))
	assert_eq(int(data["version"]), 1)
	assert_gt(int(data["saved_at"]), 1700000000)
	assert_gt(int(data["time"]["rust_lock"]["ends_at"]), int(data["saved_at"]))


func test_autosave_on_request() -> void:
	_suite()
	EventBus.autosave_requested.emit()
	await wait_seconds(SaveManager.AUTOSAVE_DELAY + 0.2)
	assert_true(SaveManager.has_save())

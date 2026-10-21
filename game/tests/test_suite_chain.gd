extends GutTest
## L-5: the whole princess-suite chain (docs/PUZZLES.md v1.2) through the
## game's own API, in the real scene: hairpin, chair, orange, juice at the
## workbench; ball -> chandelier -> key -> garderobe -> code 5309 -> chest
## (backpack + Handbook); the ghost in the wardrobe, her three riddles;
## salted juice on the lock -> real-time rust process -> hairpin -> gate;
## candle + matches -> into the dark -> "To be continued". With a save and a
## load in the middle.

const SUITE: String = "res://scenes/rooms/princess_suite.tscn"
const TEST_SAVE: String = "user://test_chain_save.json"

var scene: Node


func before_all() -> void:
	SaveManager.load_on_start = false
	SaveManager.save_path = TEST_SAVE
	SaveManager.delete_save()
	GameManager.reset()
	GameManager.mode = "classic"
	TimeManager.clear()


func after_all() -> void:
	SaveManager.delete_save()
	SaveManager.save_path = SaveManager.SAVE_PATH
	SaveManager.load_on_start = true
	GameManager.reset()
	TimeManager.clear()
	EventBus.set_modal_ui(false)


func _load_suite() -> void:
	scene = (load(SUITE) as PackedScene).instantiate()
	add_child_autofree(scene)


func _prop(path: String) -> Node:
	return scene.get_node(path)


func _hud() -> Hud:
	return scene.get_node("Hud") as Hud


func _first_child(of: Node, type_name: String) -> Node:
	for child: Node in of.get_children():
		if child.get_class() == type_name or (child.get_script() and child.get_script().get_global_name() == type_name):
			return child
	return null


func test_the_whole_chain() -> void:
	_load_suite()
	var root: Control = _hud().get_child(0) as Control
	# 1. Hairpin from the vanity.
	await (_prop("Props/Vanity") as Interactable).use()
	assert_true(GameManager.inventory.has("hairpin"), "hairpin")
	# 2-3. Chair under the tree, then an orange.
	await (_prop("Props/XChair") as PushProp).push()
	assert_true(GameManager.has_flag("chair_under_tree"))
	await (_prop("Props/OrangeTree") as Interactable).use()
	assert_true(GameManager.inventory.has("orange"), "orange")
	# 4. Juice at the workbench (ChemistryEngine).
	assert_true(ChemistryEngine.run("squeeze_orange")["ok"])
	assert_true(GameManager.inventory.has("orange_juice"))
	assert_true("citric_acid" in GameManager.codex)

	# Backpack branch: ball -> chandelier -> key -> garderobe -> 5309 -> chest.
	var chandelier: Chandelier = _prop("Chandelier")
	chandelier.register_hit(true)
	await wait_seconds(0.5)
	assert_true((_prop("Props/KeyPickup") as Pickup).take(), "the key fell out")
	GameManager.equip("key", 1)
	GameManager.use_held_on("garderobe_door")
	assert_true(GameManager.has_flag("garderobe_unlocked"), "Princess logic")
	var lock: CodeLock = _first_child(root, "CodeLock")
	await (_prop("Props/Chest") as Interactable).use()
	assert_true(lock.visible, "The chest asks for the code")
	lock.digits = [8, 6, 7, 0]
	assert_false(lock.try_open(), "867 is not it")
	lock.digits = [5, 3, 0, 9]
	assert_true(lock.try_open())
	await wait_until(func() -> bool: return GameManager.has_flag("has_backpack"), 3.0)
	assert_eq(GameManager.inventory.capacity, 36)
	assert_true(GameManager.has_flag("has_handbook"))

	# Save in the middle, load into a fresh scene.
	assert_true(SaveManager.save_game())
	scene.free()
	GameManager.reset()
	_load_suite()
	root = _hud().get_child(0) as Control
	assert_true(SaveManager.load_game())
	assert_true(GameManager.inventory.has("orange_juice"), "survived the load")
	assert_true((_prop("Props/Chest") as Interactable).is_open, "chest stays open")

	# The ghost in the wardrobe: intro, then the riddles.
	var wardrobe: Interactable = _prop("Props/Wardrobe")
	await wardrobe.use()
	var box: DialogueBox = _first_child(root, "DialogueBox")
	await wait_until(func() -> bool: return box.visible, 2.0)
	for i: int in 4:
		box.advance()
	assert_true(GameManager.has_flag("ghost_met"))
	assert_true(_hud().hint_button.visible, "The crown appears")
	var riddles: RiddlePanel = _first_child(root, "RiddlePanel")
	for answer: Array in [["sugar", "salt"], ["fireplace", "candle"], ["garlic", "silver_spoon"]]:
		riddles.ask_next()
		assert_false(riddles.answer(answer[0]), "grumble, try again")
		assert_true(riddles.answer(answer[1]))
	for id: String in ["salt", "candle", "silver_spoon"]:
		assert_true(GameManager.inventory.has(id), id)

	# Salted juice on the lock: a real-time process (classic: 15 min / 2).
	assert_true(ChemistryEngine.run("salt_juice")["ok"])
	GameManager.equip("salted_juice", 0)
	GameManager.use_held_on("dressing_gate")
	assert_true(TimeManager.is_running("rust_lock"))
	assert_eq(TimeManager.remaining("rust_lock"), 450)
	GameManager.equip("hairpin", 1)
	GameManager.use_held_on("dressing_gate")
	assert_false(GameManager.has_flag("gate_unlocked"), "It's rusted solid.")
	TimeManager.clock_offset = 451.0
	TimeManager.check()
	assert_true(GameManager.has_flag("lock_rust_gone"))
	GameManager.use_held_on("dressing_gate")
	assert_true(GameManager.has_flag("gate_unlocked"))
	await wait_until(func() -> bool: return (_prop("Props/DressingGate") as Interactable).is_open, 6.0)
	assert_true((_prop("Props/DarkPassage") as Node2D).visible, "The dark passage")

	# A light: candle + matches (nightstand), then into the dark.
	await (_prop("Props/Nightstand") as Interactable).use()
	GameManager.equip("candle", 0)
	GameManager.equip("matches", 1)
	assert_true(GameManager.inventory.combine()["ok"])
	GameManager.use_held_on("dark_passage")
	await wait_until(func() -> bool: return GameManager.has_flag("suite_done"), 5.0)
	assert_true(GameManager.has_flag("suite_done"), "To be continued: the castle stairs")


func test_toilet_remote_plays_parody_tracks() -> void:
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/first_person/garderobe.json"))
	var tracks: int = 0
	for button: Dictionary in data["closeups"]["remote"]:
		if String(button.get("sfx", "")).begins_with("jingle_"):
			tracks += 1
			assert_true(AudioManager.has_sfx(button["sfx"]), button["sfx"])
	assert_eq(tracks, 3)


func test_every_new_string_exists() -> void:
	var text: String = FileAccess.get_file_as_string("res://data/i18n/strings.csv")
	var riddles: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/riddles.json"))
	for riddle: Dictionary in riddles["riddles"]:
		for key: String in [riddle["question_key"], riddle["grumble_key"]]:
			assert_true(text.contains("\n" + key + ","), key)
	var dialogues: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/dialogues.json"))
	for line: Dictionary in dialogues["ghost_intro"]:
		assert_true(text.contains("\n" + line["key"] + ","), line["key"])
	var rules: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/use_rules.json"))
	for rule: Dictionary in rules["rules"]:
		for key: String in [rule.get("verb", "UI_USE"), rule.get("line_key", ""), rule.get("blocked_line_key", "")]:
			if not key.is_empty():
				assert_true(text.contains("\n" + key + ","), key)

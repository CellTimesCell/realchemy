extends GutTest
## L-1: pockets and hands. Stacking, the pajama limit of 6, equip / put away
## / swap, Combine by data/hand_recipes.json, the backpack (6 -> 36), item
## verbs from use rules, saving the inventory.


func before_each() -> void:
	GameManager.reset()


func test_add_and_stack() -> void:
	var inv: Inventory = Inventory.new()
	assert_true(inv.add("orange"))
	assert_true(inv.add("orange", 2))
	assert_eq(inv.used_slots(), 1, "Oranges stack in one slot")
	assert_eq(inv.count_of("orange"), 3)
	assert_true(inv.add("key"))
	assert_true(inv.add("hairpin"))
	assert_eq(inv.used_slots(), 3)


func test_pajamas_hold_six() -> void:
	var inv: Inventory = Inventory.new()
	for id: String in ["key", "hairpin", "ball", "salt", "candle", "matches"]:
		assert_true(inv.add(id), id)
	assert_false(inv.add("stockings"), "Two pockets. Life is hard.")
	assert_true(inv.add("matches") == false or ItemDb.is_stackable("matches"))
	assert_eq(inv.capacity, Inventory.POCKETS)


func test_full_pockets_line_and_item_stays() -> void:
	for id: String in ["key", "hairpin", "ball", "salt", "candle", "matches"]:
		GameManager.give_item(id)
	watch_signals(EventBus)
	assert_false(GameManager.give_item("stockings"))
	assert_signal_emitted_with_parameters(EventBus, "hero_line_requested", ["SAY_POCKETS_FULL"])
	assert_false(GameManager.inventory.has("stockings"))


func test_backpack_grows_to_36() -> void:
	for id: String in ["key", "hairpin", "ball", "salt", "candle", "matches"]:
		GameManager.give_item(id)
	assert_true(GameManager.give_item("backpack"))
	assert_eq(GameManager.inventory.capacity, Inventory.BACKPACK)
	assert_eq(GameManager.inventory.used_slots(), 6, "Nothing lost, the backpack is not a slot")
	assert_true(GameManager.give_item("stockings"))
	assert_true(GameManager.has_flag("has_backpack"))


func test_equip_put_away_swap() -> void:
	var inv: Inventory = Inventory.new()
	inv.add("key")
	inv.add("ball")
	assert_true(inv.equip(0, Inventory.Hand.LEFT))
	assert_eq(inv.held(Inventory.Hand.LEFT), "key")
	assert_eq(inv.used_slots(), 1, "Hands don't use pocket space")
	assert_true(inv.equip(1, Inventory.Hand.RIGHT))
	assert_eq(inv.active_items(), ["ball", "key"] as Array[String], "Last taken first")
	inv.swap_hands()
	assert_eq(inv.held(Inventory.Hand.LEFT), "ball")
	assert_true(inv.put_away(Inventory.Hand.LEFT))
	assert_eq(inv.held(Inventory.Hand.LEFT), "")
	assert_true(inv.has("ball"))


func test_equip_replaces_and_returns_previous() -> void:
	var inv: Inventory = Inventory.new()
	inv.add("key")
	inv.add("ball")
	inv.equip(0, Inventory.Hand.LEFT)
	inv.equip(1, Inventory.Hand.LEFT)
	assert_eq(inv.held(Inventory.Hand.LEFT), "ball")
	assert_true(inv.has("key"), "The key went back to the pockets")
	assert_eq(inv.count_of("key"), 1)


func test_combine_candle_and_matches() -> void:
	var inv: Inventory = Inventory.new()
	inv.add("candle")
	inv.add("matches")
	inv.equip(0, Inventory.Hand.LEFT)
	inv.equip(1, Inventory.Hand.RIGHT)
	var result: Dictionary = inv.combine()
	assert_true(result["ok"])
	assert_eq(result["line_key"], "SAY_CANDLE_LIT")
	assert_true(inv.has("lit_candle"))
	assert_false(inv.has("candle"))
	assert_true(inv.has("matches"), "Matches are a tool, they stay")


func test_combine_fail() -> void:
	var inv: Inventory = Inventory.new()
	inv.add("key")
	inv.add("ball")
	inv.equip(0, Inventory.Hand.LEFT)
	inv.equip(1, Inventory.Hand.RIGHT)
	var result: Dictionary = inv.combine()
	assert_false(result["ok"])
	assert_eq(result["line_key"], "SAY_COMBINE_FAIL")
	assert_true(inv.has("key") and inv.has("ball"), "Nothing lost")


func test_item_prompt_from_use_rules() -> void:
	GameManager.give_item("key")
	assert_eq(GameManager.item_prompt("garderobe_door"), "", "Not in hand yet")
	GameManager.inventory.equip(0, Inventory.Hand.RIGHT)
	assert_ne(GameManager.item_prompt("garderobe_door"), "")
	GameManager.use_held_on("garderobe_door")
	assert_true(GameManager.has_flag("garderobe_unlocked"))
	assert_eq(GameManager.item_prompt("garderobe_door"), "", "Done once, the verb is gone")


func test_inventory_round_trip() -> void:
	var inv: Inventory = Inventory.new()
	inv.add("orange", 2)
	inv.add("key")
	inv.equip(1, Inventory.Hand.RIGHT)
	inv.grow(Inventory.BACKPACK)
	var copy: Inventory = Inventory.new()
	copy.from_dict(JSON.parse_string(JSON.stringify(inv.to_dict())))
	assert_eq(copy.capacity, 36)
	assert_eq(copy.count_of("orange"), 2)
	assert_eq(copy.held(Inventory.Hand.RIGHT), "key")


func test_every_item_has_strings() -> void:
	var text: String = FileAccess.get_file_as_string("res://data/i18n/strings.csv")
	for id: String in ItemDb.all():
		assert_true(text.contains("\n" + ItemDb.name_key(id) + ","), ItemDb.name_key(id))
		assert_true(text.contains("\n" + ItemDb.desc_key(id) + ","), ItemDb.desc_key(id))

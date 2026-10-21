extends Node
## Game state: difficulty mode, story / puzzle flags, the hero's inventory
## and stats, unlocked Codex entries. Puzzle logic is data: use rules
## (data/use_rules.json) say what an item in hand does to a target - set
## flags, give or use up items, start a real-time process, fire a named
## puzzle event for the scene - and what the hero says. Systems talk to the
## scene through EventBus. Saved by SaveManager (to_dict / from_dict).

enum State { PLAYING, MODAL }

const RULES_PATH: String = "res://data/use_rules.json"
const MODES: Array[String] = ["cozy", "classic", "real"]
const POCKETS_FULL_KEY: String = "SAY_POCKETS_FULL"

var state: State = State.PLAYING
var mode: String = "classic"
var flags: Dictionary = {}
var inventory: Inventory = Inventory.new()
var stats: HeroStats = HeroStats.new()
var codex: Array[String] = []
## Current room id (bedroom / boudoir / dressing) and the hero's position.
var room: String = "bedroom"
var hero_position: Vector2 = Vector2.ZERO
var rules: Array = []


func _ready() -> void:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(RULES_PATH))
	rules = parsed.get("rules", []) if parsed is Dictionary else []
	inventory.changed.connect(func() -> void: EventBus.inventory_changed.emit())
	stats.changed.connect(func() -> void: EventBus.stats_changed.emit())
	EventBus.modal_ui_changed.connect(func(active: bool) -> void:
		state = State.MODAL if active else State.PLAYING)


## Back to the very start (new game, tests).
func reset() -> void:
	flags.clear()
	codex.clear()
	inventory = Inventory.new()
	inventory.changed.connect(func() -> void: EventBus.inventory_changed.emit())
	stats = HeroStats.new()
	stats.changed.connect(func() -> void: EventBus.stats_changed.emit())
	room = "bedroom"
	hero_position = Vector2.ZERO
	EventBus.inventory_changed.emit()
	EventBus.stats_changed.emit()


# --- Flags --------------------------------------------------------------------

func set_flag(flag: String, value: Variant = true) -> void:
	if flags.get(flag) == value:
		return
	flags[flag] = value
	EventBus.flag_changed.emit(flag, value)


func clear_flag(flag: String) -> void:
	if flags.erase(flag):
		EventBus.flag_changed.emit(flag, null)


func has_flag(flag: String) -> bool:
	return bool(flags.get(flag, false))


func flags_met(need: Array, forbid: Array = []) -> bool:
	for flag: String in need:
		if not has_flag(flag):
			return false
	for flag: String in forbid:
		if has_flag(flag):
			return false
	return true


# --- Items --------------------------------------------------------------------

## Picks an item up. Special items act at once (the backpack grows the
## pockets, the handbook opens the Codex). False when the pockets are full
## (the hero says so; the item stays where it was).
func give_item(id: String, count: int = 1) -> bool:
	match ItemDb.special(id):
		"backpack":
			inventory.grow(Inventory.BACKPACK)
			set_flag("has_backpack")
			EventBus.item_found.emit(id)
			return true
		"codex":
			set_flag("has_handbook")
			EventBus.item_found.emit(id)
			return true
	if not inventory.add(id, count):
		EventBus.hero_line_requested.emit(POCKETS_FULL_KEY)
		return false
	# had_<item>: the puzzle graph knows the hero got it once (data/hints.json).
	set_flag("had_%s" % id)
	EventBus.item_found.emit(id)
	return true


## Takes an item from the pockets into a hand (0 = left, 1 = right).
func equip(id: String, hand: int) -> bool:
	for i: int in inventory.slots.size():
		if inventory.slots[i].get("id", "") == id:
			return inventory.equip(i, hand as Inventory.Hand)
	return false


## Xp for a stat (an action well done); true on a level up.
func add_xp(stat: String, amount: int) -> bool:
	return stats.add_xp(stat, amount)


func unlock_codex(entry_id: String) -> void:
	if entry_id.is_empty() or entry_id in codex:
		return
	codex.append(entry_id)
	EventBus.codex_unlocked.emit(entry_id)


# --- Use rules: an item in hand on a target -------------------------------------

## The first rule for one of the held items on this target, with the item:
## {"rule": {...}, "item": id} or {} when nothing in hand applies.
func rule_for(target_id: String) -> Dictionary:
	for item: String in inventory.active_items():
		for rule: Dictionary in rules:
			if rule.get("target", "") == target_id and rule.get("item", "") == item \
					and flags_met([], rule.get("hide_if", [])):
				return {"rule": rule, "item": item}
	return {}


## The prompt for using what is in hand on a target ("Use (Orange juice)"),
## or "" when nothing applies.
func item_prompt(target_id: String) -> String:
	var found: Dictionary = rule_for(target_id)
	if found.is_empty():
		return ""
	return "%s (%s)" % [tr(found["rule"].get("verb", "UI_USE")), tr(ItemDb.name_key(found["item"]))]


## Applies the held item to a target. Returns the rule used ({} if none).
func use_held_on(target_id: String) -> Dictionary:
	var found: Dictionary = rule_for(target_id)
	if found.is_empty():
		return {}
	apply_rule(found["rule"], found["item"])
	return found["rule"]


func apply_rule(rule: Dictionary, item: String) -> void:
	if not flags_met(rule.get("requires", []), rule.get("forbid", [])):
		EventBus.hero_line_requested.emit(rule.get("blocked_line_key", ""))
		return
	EventBus.hero_pose_requested.emit(rule.get("pose", "interact_mid"))
	if rule.get("consume", false):
		inventory.consume_held(item)
	for flag: String in rule.get("set_flags", []):
		set_flag(flag)
	for flag: String in rule.get("clear_flags", []):
		clear_flag(flag)
	for gift: Dictionary in rule.get("give", []):
		give_item(gift["id"], int(gift.get("count", 1)))
	var process: Dictionary = rule.get("start_process", {})
	if not process.is_empty():
		TimeManager.start_reaction(process["reaction"], process.get("id", process["reaction"]), item)
	stats.add_xp(rule.get("xp_stat", ""), int(rule.get("xp", 0)))
	if rule.has("codex"):
		unlock_codex(rule["codex"])
	if rule.has("event"):
		EventBus.puzzle_event.emit(rule["event"])
	EventBus.hero_line_requested.emit(rule.get("line_key", ""))
	EventBus.autosave_requested.emit()


# --- Save ---------------------------------------------------------------------

func to_dict() -> Dictionary:
	return {
		"mode": mode, "flags": flags.duplicate(true), "inventory": inventory.to_dict(),
		"stats": stats.to_dict(), "codex": codex.duplicate(), "room": room,
		"hero": [hero_position.x, hero_position.y],
	}


func from_dict(data: Dictionary) -> void:
	mode = data.get("mode", "classic")
	flags = data.get("flags", {}).duplicate(true)
	inventory.from_dict(data.get("inventory", {}))
	stats.from_dict(data.get("stats", {}))
	codex.assign(data.get("codex", []))
	room = data.get("room", "bedroom")
	var pos: Array = data.get("hero", [0, 0])
	hero_position = Vector2(pos[0], pos[1])
	EventBus.inventory_changed.emit()
	EventBus.stats_changed.emit()

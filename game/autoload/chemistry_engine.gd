extends Node
## Reactions from data/reactions.json (abstracted, CLAUDE.md §6). find()
## matches what the hero has against a reaction's inputs (exact ids or
## "tag:x"); run() at a zone uses them up and gives the outputs (instant
## reactions) - real-time ones go to TimeManager. Durations depend on the
## difficulty mode; a "speedup" item (salted juice) shortens them.

const PATH: String = "res://data/reactions.json"
const CODEX_PATH: String = "res://data/codex.json"

var reactions: Dictionary = {}
var codex_entries: Dictionary = {}


func _ready() -> void:
	reactions = _load(PATH)
	codex_entries = _load(CODEX_PATH)


func get_reaction(reaction_id: String) -> Dictionary:
	return reactions.get(reaction_id, {})


## Does an item satisfy one input ("orange" or "tag:rust_remover")?
func matches_input(input: String, item: String) -> bool:
	if input.begins_with("tag:"):
		return ItemDb.has_tag(item, input.substr(4))
	return input == item


## Seconds a reaction takes in a mode; `used_item` may speed it up.
func duration_for(reaction_id: String, mode: String, used_item: String = "") -> int:
	var reaction: Dictionary = get_reaction(reaction_id)
	var seconds: float = float(reaction.get("duration", {}).get("modes", {}).get(mode, 0))
	seconds *= float(reaction.get("speedup", {}).get(used_item, 1.0))
	return int(round(seconds))


## The inventory items (pockets and hands) that fill a reaction's inputs, or
## [] if something is missing.
func gather(reaction_id: String, inventory: Inventory) -> Array[String]:
	var picked: Array[String] = []
	for input: String in get_reaction(reaction_id).get("inputs", []):
		var found: String = ""
		for slot: Dictionary in inventory.slots:
			var id: String = slot.get("id", "")
			if not id.is_empty() and matches_input(input, id) and picked.count(id) < inventory.count_of(id):
				found = id
				break
		if found.is_empty():
			for id: String in inventory.hands:
				if not id.is_empty() and matches_input(input, id) and picked.count(id) < inventory.count_of(id):
					found = id
					break
		if found.is_empty():
			return []
		picked.append(found)
	return picked


## Runs an instant reaction from the hero's things. Returns
## {"ok": bool, "line_key": key, "outputs": [...]}.
func run(reaction_id: String) -> Dictionary:
	var reaction: Dictionary = get_reaction(reaction_id)
	var inventory: Inventory = GameManager.inventory
	var used: Array[String] = gather(reaction_id, inventory)
	if reaction.is_empty() or used.is_empty():
		EventBus.reaction_failed.emit(reaction_id)
		return {"ok": false, "line_key": reaction.get("missing_line_key", ""), "outputs": []}
	for id: String in used:
		if id in reaction.get("consumes", []):
			inventory.remove(id)
	var outputs: Array = reaction.get("outputs", [])
	for id: String in outputs:
		GameManager.give_item(id)
	GameManager.unlock_codex(reaction.get("codex", ""))
	EventBus.reaction_completed.emit(reaction_id)
	return {"ok": true, "line_key": reaction.get("line_key", ""), "outputs": outputs}


func codex_title(entry_id: String) -> String:
	return codex_entries.get(entry_id, {}).get("title", {}).get("en", entry_id)


func codex_text(entry_id: String) -> String:
	return codex_entries.get(entry_id, {}).get("text", {}).get("en", "")


func _load(path: String) -> Dictionary:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	var result: Dictionary = {}
	if parsed is Dictionary:
		for key: String in parsed:
			if not key.begins_with("_"):
				result[key] = parsed[key]
	return result

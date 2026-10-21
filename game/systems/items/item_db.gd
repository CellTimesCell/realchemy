class_name ItemDb
extends RefCounted
## Read-only item table from data/items.json: names, inspect lines, icons
## (or placeholder colour + letter), stacking, tags.

const PATH: String = "res://data/items.json"

static var _items: Dictionary = {}


static func all() -> Dictionary:
	if _items.is_empty():
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
		if parsed is Dictionary:
			for id: String in parsed:
				if not id.begins_with("_"):
					_items[id] = parsed[id]
	return _items


static func has(id: String) -> bool:
	return all().has(id)


static func get_item(id: String) -> Dictionary:
	return all().get(id, {})


static func name_key(id: String) -> String:
	return get_item(id).get("name_key", id)


static func desc_key(id: String) -> String:
	return get_item(id).get("desc_key", "")


static func is_stackable(id: String) -> bool:
	return get_item(id).get("stack", false)


static func special(id: String) -> String:
	return get_item(id).get("special", "")


static func color(id: String) -> Color:
	return Color(get_item(id).get("color", "#ffffff"))


static func letter(id: String) -> String:
	return get_item(id).get("letter", "?")


## The approved sprite, or null (then UI draws the placeholder square).
static func icon(id: String) -> Texture2D:
	var path: String = get_item(id).get("icon", "")
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	return load(path) as Texture2D


static func has_tag(id: String, tag: String) -> bool:
	return tag in get_item(id).get("tags", [])

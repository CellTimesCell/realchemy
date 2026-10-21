class_name Hints
extends RefCounted
## Where the player is in the suite's puzzle graph (data/hints.json): the
## current step from GameManager flags, the hero's thought for it and the
## ghost's three hint levels with a real-time cooldown per mode.

const PATH: String = "res://data/hints.json"
const MAX_LEVEL: int = 3

static var _data: Dictionary = {}


static func data() -> Dictionary:
	if _data.is_empty():
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
		_data = parsed if parsed is Dictionary else {"steps": []}
	return _data


## The current step ({} when everything is solved).
static func current_step() -> Dictionary:
	for step: Dictionary in data().get("steps", []):
		if GameManager.flags_met(step.get("need", []), step.get("forbid", [])):
			return step
	return {}


static func thought_key() -> String:
	return current_step().get("thought_key", "")


static func cooldown(mode: String) -> float:
	return float(data().get("cooldown", {}).get(mode, 45))


## The next hint for the current step (levels 1 -> 2 -> 3, then stays at 3),
## or the cooldown / nothing-to-say line. Updates the flags it keeps:
## hint_level_<step>, hint_time (Unix seconds of the last hint).
static func next_hint(now: float) -> Dictionary:
	var step: Dictionary = current_step()
	if step.is_empty():
		return {"key": data().get("none_line_key", ""), "level": 0}
	var last: float = float(GameManager.flags.get("hint_time", -1.0e9))
	if now - last < cooldown(GameManager.mode):
		EventBus.hint_on_cooldown.emit()
		return {"key": data().get("cooldown_line_key", ""), "level": -1}
	var level_flag: String = "hint_level_%s" % step["id"]
	var level: int = mini(int(GameManager.flags.get(level_flag, 0)) + 1, MAX_LEVEL)
	GameManager.set_flag(level_flag, level)
	GameManager.set_flag("hint_time", now)
	EventBus.hint_given.emit(level)
	return {"key": step["hints"][level - 1], "level": level}

class_name HeroStats
extends RefCounted
## The hero's guild card: INT, STR, DEX, WIT, LUCK (data/hero_stats.json),
## health and energy, xp per stat and the rank (F; E later - structure only).
## Stats only ever help: they shorten a push or a lock pick, make the hero
## think aloud sooner. Nothing is ever locked behind a stat.

signal changed

const PATH: String = "res://data/hero_stats.json"

static var _data: Dictionary = {}

var xp: Dictionary = {}
var health: int = 0
var energy: int = 0


func _init() -> void:
	health = health_max()
	energy = energy_max()
	for stat: String in order():
		xp[stat] = 0


static func data() -> Dictionary:
	if _data.is_empty():
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
		_data = parsed if parsed is Dictionary else {}
	return _data


static func order() -> Array:
	return data().get("order", [])


static func health_max() -> int:
	return int(data().get("health_max", 10))


static func energy_max() -> int:
	return int(data().get("energy_max", 10))


static func rank() -> String:
	return data().get("rank", {}).get("current", "F")


func level(stat: String) -> int:
	var lvl: int = 0
	for need: int in data().get("xp_per_level", []):
		if int(xp.get(stat, 0)) >= need:
			lvl += 1
	return mini(lvl, int(data().get("max_level", 4)))


func value(stat: String) -> int:
	return int(data().get("stats", {}).get(stat, {}).get("start", 1)) + level(stat)


func total_xp() -> int:
	var total: int = 0
	for stat: String in xp:
		total += int(xp[stat])
	return total


## Xp for an action; true when the stat went up a level.
func add_xp(stat: String, amount: int) -> bool:
	if stat.is_empty() or amount <= 0 or not xp.has(stat):
		return false
	var before: int = value(stat)
	xp[stat] = int(xp[stat]) + amount
	changed.emit()
	return value(stat) > before


## A puzzle timing for a stat: base + per_point * value, never below min.
func effect(stat: String, what: String) -> float:
	var table: Dictionary = data().get("effects", {}).get(stat, {})
	var base: float = float(table.get(what + "_base", 0.0))
	var per_point: float = float(table.get(what + "_per_point", 0.0))
	return maxf(float(table.get(what + "_min", 0.0)), base + per_point * value(stat))


func to_dict() -> Dictionary:
	return {"xp": xp.duplicate(), "health": health, "energy": energy}


func from_dict(saved: Dictionary) -> void:
	for stat: String in saved.get("xp", {}):
		xp[stat] = int(saved["xp"][stat])
	health = int(saved.get("health", health_max()))
	energy = int(saved.get("energy", energy_max()))
	changed.emit()

class_name Inventory
extends RefCounted
## The hero's pockets and two hands. Pockets: a fixed number of slots
## (pajamas 2x3 = 6; the backpack makes it 6x6 = 36); a stackable item keeps
## one slot with a count. Hands: Left / Right hold one unit each, taken out of
## the pockets (hands do not use pocket space). The item in a hand is active:
## hotspots offer a verb with it. Both hands full -> combine() by
## data/hand_recipes.json (mechanical, instant).

signal changed

enum Hand { LEFT, RIGHT }

const POCKETS: int = 6
const BACKPACK: int = 36
const RECIPES_PATH: String = "res://data/hand_recipes.json"

static var _recipes: Dictionary = {}

var capacity: int = POCKETS
## Each slot: {"id": String, "count": int}; an empty slot is {}.
var slots: Array[Dictionary] = []
var hands: Array[String] = ["", ""]
## The hand that took something last (its item is offered first).
var last_hand: Hand = Hand.RIGHT


func _init() -> void:
	_resize(capacity)


static func recipes() -> Dictionary:
	if _recipes.is_empty():
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(RECIPES_PATH))
		_recipes = parsed if parsed is Dictionary else {"recipes": []}
	return _recipes


## Puts one or more of an item into the pockets. False (nothing changes)
## when it does not fit.
func add(id: String, count: int = 1) -> bool:
	if ItemDb.is_stackable(id):
		var at: int = _find(id)
		if at >= 0:
			slots[at]["count"] = int(slots[at]["count"]) + count
			changed.emit()
			return true
	var free: int = _first_free()
	if free < 0:
		return false
	slots[free] = {"id": id, "count": count if ItemDb.is_stackable(id) else 1}
	if not ItemDb.is_stackable(id) and count > 1:
		for i: int in count - 1:
			if not add(id):
				break
	changed.emit()
	return true


func can_add(id: String) -> bool:
	return _first_free() >= 0 or (ItemDb.is_stackable(id) and _find(id) >= 0)


## Removes from the pockets first, then from the hands.
func remove(id: String, count: int = 1) -> bool:
	if count_of(id) < count:
		return false
	for n: int in count:
		var at: int = _find(id)
		if at >= 0:
			_take_one(at)
		elif hands[Hand.LEFT] == id:
			hands[Hand.LEFT] = ""
		elif hands[Hand.RIGHT] == id:
			hands[Hand.RIGHT] = ""
	changed.emit()
	return true


func has(id: String) -> bool:
	return count_of(id) > 0


## Pockets and hands together.
func count_of(id: String) -> int:
	var total: int = 0
	for slot: Dictionary in slots:
		if slot.get("id", "") == id:
			total += int(slot["count"])
	for held: String in hands:
		if held == id:
			total += 1
	return total


func used_slots() -> int:
	var used: int = 0
	for slot: Dictionary in slots:
		if not slot.is_empty():
			used += 1
	return used


## Takes one unit from a pocket slot into a hand; what the hand held goes
## back to the pockets (swapped into the freed slot if needed).
func equip(slot_index: int, hand: Hand) -> bool:
	if slot_index < 0 or slot_index >= slots.size() or slots[slot_index].is_empty():
		return false
	var id: String = slots[slot_index]["id"]
	var previous: String = hands[hand]
	_take_one(slot_index)
	hands[hand] = id
	last_hand = hand
	if not previous.is_empty() and not _put_back(previous, slot_index):
		# Nowhere to put it: undo.
		hands[hand] = previous
		add(id)
		return false
	changed.emit()
	return true


func put_away(hand: Hand) -> bool:
	var id: String = hands[hand]
	if id.is_empty() or not can_add(id):
		return false
	hands[hand] = ""
	add(id)
	changed.emit()
	return true


func swap_hands() -> void:
	hands.reverse()
	changed.emit()


func held(hand: Hand) -> String:
	return hands[hand]


## Items in hand, the last-used hand first.
func active_items() -> Array[String]:
	var first: String = hands[last_hand]
	var second: String = hands[Hand.RIGHT if last_hand == Hand.LEFT else Hand.LEFT]
	var result: Array[String] = []
	for id: String in [first, second]:
		if not id.is_empty():
			result.append(id)
	return result


## Drops the held unit of `id` (it was used up on something).
func consume_held(id: String) -> bool:
	for hand: int in [last_hand, Hand.LEFT, Hand.RIGHT]:
		if hands[hand] == id:
			hands[hand] = ""
			changed.emit()
			return true
	return false


func both_hands_full() -> bool:
	return not hands[Hand.LEFT].is_empty() and not hands[Hand.RIGHT].is_empty()


## The recipe for what is in the hands, or {} if they don't go together.
func find_recipe() -> Dictionary:
	if not both_hands_full():
		return {}
	var pair: Array[String] = [hands[Hand.LEFT], hands[Hand.RIGHT]]
	for recipe: Dictionary in recipes().get("recipes", []):
		if (recipe["a"] == pair[0] and recipe["b"] == pair[1]) or (recipe["a"] == pair[1] and recipe["b"] == pair[0]):
			return recipe
	return {}


## Combines the two hands. Returns {"ok": bool, "result": id, "line_key": key}.
func combine() -> Dictionary:
	var recipe: Dictionary = find_recipe()
	if recipe.is_empty():
		return {"ok": false, "result": "", "line_key": recipes().get("fail_line_key", "")}
	var consumed: Array = recipe.get("consume", [recipe["a"], recipe["b"]])
	# The result lands in the hand of a used-up item; a tool stays in its hand.
	var target: int = -1
	for hand: int in [Hand.LEFT, Hand.RIGHT]:
		if hands[hand] in consumed:
			if target < 0:
				target = hand
			else:
				hands[hand] = ""
	if target < 0:
		add(recipe["result"])
	else:
		hands[target] = recipe["result"]
		last_hand = target as Hand
	changed.emit()
	return {"ok": true, "result": recipe["result"], "line_key": recipe.get("line_key", "")}


## The backpack: pockets grow to 36 slots, nothing is lost.
func grow(new_capacity: int) -> void:
	if new_capacity > capacity:
		_resize(new_capacity)
		changed.emit()


func to_dict() -> Dictionary:
	return {"capacity": capacity, "slots": slots.duplicate(true), "hands": hands.duplicate(), "last_hand": last_hand}


func from_dict(data: Dictionary) -> void:
	_resize(int(data.get("capacity", POCKETS)))
	var saved: Array = data.get("slots", [])
	for i: int in mini(saved.size(), slots.size()):
		var slot: Dictionary = saved[i]
		slots[i] = {} if slot.is_empty() else {"id": String(slot["id"]), "count": int(slot["count"])}
	var saved_hands: Array = data.get("hands", ["", ""])
	hands = [String(saved_hands[0]), String(saved_hands[1])]
	last_hand = int(data.get("last_hand", Hand.RIGHT)) as Hand
	changed.emit()


func _resize(new_capacity: int) -> void:
	capacity = new_capacity
	while slots.size() < capacity:
		slots.append({})


func _find(id: String) -> int:
	for i: int in slots.size():
		if slots[i].get("id", "") == id:
			return i
	return -1


func _first_free() -> int:
	for i: int in capacity:
		if slots[i].is_empty():
			return i
	return -1


func _take_one(index: int) -> void:
	var left: int = int(slots[index]["count"]) - 1
	if left <= 0:
		slots[index] = {}
	else:
		slots[index]["count"] = left


func _put_back(id: String, preferred: int) -> bool:
	if ItemDb.is_stackable(id) and _find(id) >= 0:
		return add(id)
	if slots[preferred].is_empty():
		slots[preferred] = {"id": id, "count": 1}
		return true
	return add(id)

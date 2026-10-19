extends GutTest
## First-person garderobe: data loads, hidden scratches appear only after
## their poster moved, the toilet paper can be taken once; the arch door is
## locked only on the first try.

const VIEW_SCENE: String = "res://scenes/first_person/garderobe_view.tscn"

var _view: FirstPersonView


func before_each() -> void:
	_view = (load(VIEW_SCENE) as PackedScene).instantiate() as FirstPersonView
	add_child_autofree(_view)


func _entry(id: String) -> Dictionary:
	for entry: Dictionary in _view.data["hotspots"]:
		if entry["id"] == id:
			return entry
	return {}


func test_data_is_first_person() -> void:
	assert_eq(_view.data.get("type"), "first_person")
	for entry: Dictionary in _view.data["hotspots"]:
		assert_eq((entry["rect"] as Array).size(), 4, "%s has a rect" % entry["id"])
		assert_gt((entry["verbs"] as Array).size(), 0, "%s has verbs" % entry["id"])


func test_scratches_show_after_the_poster_moves() -> void:
	var r: Array = _entry("scratch_help")["rect"]
	var point: Vector2 = Vector2(r[0] + 4, r[1] + 4)
	assert_eq(_view.hotspot_at(point).get("id"), "poster_bonjovial", "Poster covers the wall")
	var poster: Dictionary = _entry("poster_bonjovial")
	_view.run_verb(poster, poster["verbs"][1])
	assert_eq(_view.hotspot_at(point).get("id"), "scratch_help", "Scratches revealed")


func test_toilet_paper_taken_once() -> void:
	var paper: Dictionary = _entry("toilet_paper")
	watch_signals(EventBus)
	_view.run_verb(paper, paper["verbs"][0])
	_view.run_verb(paper, paper["verbs"][0])
	assert_signal_emit_count(EventBus, "item_found", 1)
	var r: Array = paper["rect"]
	assert_ne(_view.hotspot_at(Vector2(r[0] + 2, r[1] + 2)).get("id", ""), "toilet_paper", "Gone after taking")


func test_door_locked_only_first_time() -> void:
	var door: DoorTransition = DoorTransition.new()
	door.locked_first_time = true
	door.hotspot = Hotspot.new()
	door.hotspot.prompt = Label.new()
	door.hotspot.add_child(door.hotspot.prompt)
	door.add_child(door.hotspot)
	add_child_autofree(door)
	door.hotspot._hero_inside = true
	var accept: InputEventAction = InputEventAction.new()
	accept.action = "ui_accept"
	accept.pressed = true
	door._unhandled_input(accept)
	assert_true(door._tried, "First try rattles")
	await wait_seconds(0.4)
	assert_false(door.busy, "Rattle finished")

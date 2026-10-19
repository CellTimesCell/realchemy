extends GutTest
## Boudoir props: taking items, the canary danger sensor, and emotes drawn on
## the overlay layer above the night tint.

var _accept: InputEventAction


func before_all() -> void:
	_accept = InputEventAction.new()
	_accept.action = "ui_accept"
	_accept.pressed = true


func _make_hotspot() -> Hotspot:
	var hotspot: Hotspot = Hotspot.new()
	hotspot.prompt = Label.new()
	hotspot.add_child(hotspot.prompt)
	return hotspot


func _make_interactable(id: String) -> Interactable:
	var prop: Interactable = Interactable.new()
	prop.interactable_id = id
	prop.hotspot = _make_hotspot()
	prop.add_child(prop.hotspot)
	add_child_autofree(prop)
	prop.hotspot._hero_inside = true
	return prop


func test_orange_tree_gives_oranges_until_empty() -> void:
	var prop: Interactable = _make_interactable("orange_tree")
	watch_signals(EventBus)
	for i: int in 4:
		prop._unhandled_input(_accept)
	assert_signal_emit_count(EventBus, "item_found", 3, "Three oranges, then none")
	assert_eq(prop.hotspot.prompt.text, "SAY_ORANGE_EMPTY")
	assert_eq(prop.hotspot.prompt_text, "UI_INSPECT", "Prompt changes once empty")


func test_interactable_ignores_input_when_hero_away() -> void:
	var prop: Interactable = _make_interactable("vanity")
	prop.hotspot._hero_inside = false
	watch_signals(EventBus)
	prop._unhandled_input(_accept)
	assert_signal_emit_count(EventBus, "item_found", 0)


func test_states_go_closed_ajar_open() -> void:
	var prop: Interactable = Interactable.new()
	prop.interactable_id = "wardrobe"
	prop.hotspot = _make_hotspot()
	prop.add_child(prop.hotspot)
	prop.sprite = Sprite2D.new()
	prop.add_child(prop.sprite)
	var textures: Array[Texture2D] = [PlaceholderTexture2D.new(), PlaceholderTexture2D.new(), PlaceholderTexture2D.new()]
	prop.state_textures = textures
	add_child_autofree(prop)
	assert_eq(prop.sprite.texture, textures[0], "Starts closed")
	await prop.use()
	assert_true(prop.is_open, "Opened")
	assert_eq(prop.sprite.texture, textures[2], "Ends on the open frame")


func test_locked_prop_rattles_and_stays_shut() -> void:
	var prop: Interactable = _make_interactable("dressing_gate")
	watch_signals(EventBus)
	await prop.use()
	assert_false(prop.is_open, "Locked gate stays shut")
	assert_eq(prop.hotspot.prompt.text, "SAY_GATE_LOCKED")


func test_interactables_table_is_valid() -> void:
	var table: Dictionary = Interactable.load_table()
	for id: String in table:
		if id.begins_with("_"):
			continue
		var entry: Dictionary = table[id]
		assert_has(["none", "states", "slide"], entry.get("anim", "none"), "%s: known anim" % id)
		for sfx_name: String in entry.get("sfx", {}).values():
			assert_true(AudioManager.has_sfx(sfx_name), "%s: sfx '%s' exists" % [id, sfx_name])


func test_canary_alarms_on_danger_event() -> void:
	var canary: Canary = Canary.new()
	canary.sprite_frames = SpriteFrames.new()
	for anim_name: String in ["sit", "preen", "alarm"]:
		canary.sprite_frames.add_animation(anim_name)
		canary.sprite_frames.add_frame(anim_name, PlaceholderTexture2D.new())
	add_child_autofree(canary)
	EventBus.danger_reaction_started.emit("demo")
	assert_true(canary.alarmed, "Danger event alarms the canary")
	assert_eq(canary.animation, &"alarm")


func test_emote_moves_to_overlay_and_follows_anchor() -> void:
	var anchor: Node2D = Node2D.new()
	anchor.position = Vector2(100, 50)
	var overlay: CanvasLayer = CanvasLayer.new()
	var emote: Emote = Emote.new()
	emote.overlay = overlay
	emote.sprite_frames = SpriteFrames.new()
	emote.sprite_frames.add_animation("exclaim")
	emote.sprite_frames.add_frame("exclaim", PlaceholderTexture2D.new())
	anchor.add_child(emote)
	add_child_autofree(overlay)
	add_child_autofree(anchor)
	await wait_process_frames(2)
	assert_eq(emote.get_parent(), overlay, "Emote is drawn on the overlay layer")
	emote.show_emote("exclaim")
	anchor.position = Vector2(140, 60)
	await wait_seconds(0.2)
	var offset: Array = Emote.load_table()["icons"]["exclaim"]["places"][0]["offset"]
	assert_eq(emote.global_position, Vector2(140, 60) + Vector2(offset[0], offset[1]), "Emote follows its anchor")


func _make_head_emote(face_side_flip: bool) -> Emote:
	var root: Node2D = Node2D.new()
	var head: Node2D = Node2D.new()
	for marker_name: String in ["Head_Top", "Forehead", "Temple_L", "Temple_R"]:
		var marker: Marker2D = Marker2D.new()
		marker.name = marker_name
		head.add_child(marker)
	head.get_node("Temple_L").position = Vector2(-10, 0)
	head.get_node("Temple_R").position = Vector2(10, 0)
	var body: AnimatedSprite2D = AnimatedSprite2D.new()
	body.flip_h = face_side_flip
	var emote: Emote = Emote.new()
	emote.character = "hero"
	emote.head = head
	emote.body = body
	root.add_child(head)
	root.add_child(body)
	root.add_child(emote)
	add_child_autofree(root)
	return emote


func test_emote_place_mirrors_with_facing() -> void:
	var place: Dictionary = {"anchor": "temple_face", "offset": [6, -2]}
	var right: Emote = _make_head_emote(false)
	var left: Emote = _make_head_emote(true)
	assert_false(right.looks_left(), "Hero looks right by default")
	assert_true(left.looks_left(), "Flipped hero looks left")
	assert_eq(right.place_position(place), Vector2(16, -2), "Face temple is on the right")
	assert_eq(left.place_position(place), Vector2(-16, -2), "Mirrored to the left temple")


func test_every_emote_icon_has_a_place() -> void:
	var table: Dictionary = Emote.load_table()
	var reactions: Dictionary = ReactionPlayer.load_table()["reactions"]
	for character: String in reactions:
		assert_has(table["characters"], character, "emotes.json knows '%s'" % character)
		for reaction: Dictionary in reactions[character].values():
			if not reaction["emote"].is_empty():
				assert_has(table["icons"], reaction["emote"], "Place for '%s'" % reaction["emote"])

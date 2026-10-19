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


func test_pickup_gives_items_until_empty() -> void:
	var prop: PickupProp = PickupProp.new()
	prop.hotspot = _make_hotspot()
	prop.add_child(prop.hotspot)
	prop.item_id = "orange"
	prop.count = 2
	prop.taken_say_key = "SAY_ORANGE_TAKEN"
	prop.empty_say_key = "SAY_ORANGE_EMPTY"
	add_child_autofree(prop)
	prop.hotspot._hero_inside = true
	watch_signals(EventBus)
	for i: int in 3:
		prop._unhandled_input(_accept)
	assert_signal_emit_count(EventBus, "item_found", 2, "Two oranges, then none")
	assert_eq(prop.hotspot.prompt.text, "SAY_ORANGE_EMPTY")
	assert_eq(prop.hotspot.prompt_text, "UI_INSPECT", "Prompt changes once empty")


func test_pickup_ignores_input_when_hero_away() -> void:
	var prop: PickupProp = PickupProp.new()
	prop.hotspot = _make_hotspot()
	prop.add_child(prop.hotspot)
	prop.item_id = "hairpin"
	add_child_autofree(prop)
	watch_signals(EventBus)
	prop._unhandled_input(_accept)
	assert_signal_emit_count(EventBus, "item_found", 0)


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
	anchor.add_child(emote)
	add_child_autofree(overlay)
	add_child_autofree(anchor)
	await wait_process_frames(2)
	assert_eq(emote.get_parent(), overlay, "Emote is drawn on the overlay layer")
	anchor.position = Vector2(140, 60)
	await wait_process_frames(1)
	assert_eq(emote.global_position, Vector2(140, 60), "Emote follows its anchor")

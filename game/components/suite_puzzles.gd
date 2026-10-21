class_name SuitePuzzles
extends Node
## Scene side of the suite's puzzle chain (docs/PUZZLES.md §2): the hairpin
## picks the softened lock (DEX makes it quicker, never required) and the
## gate swings open; behind it the dark passage needs a light; walking in
## with a lit candle ends the suite: "To be continued: the castle stairs".
## The rules themselves are data (data/use_rules.json).

const END_FADE: float = 1.2

@export var hero: Hero
@export var gate: Interactable
## Hotspot node in the gateway, shown once the gate is open.
@export var dark_passage: Node2D

var ending: CanvasLayer


func _ready() -> void:
	EventBus.puzzle_event.connect(_on_puzzle_event)
	EventBus.flag_changed.connect(func(_flag: String, _value: Variant) -> void: _sync())
	EventBus.game_loaded.connect(_sync)
	_sync()


func _sync() -> void:
	dark_passage.visible = GameManager.has_flag("gate_unlocked") and gate.is_open


func _on_puzzle_event(event_name: String) -> void:
	match event_name:
		"gate_pick":
			pick_lock()
		"to_be_continued":
			to_be_continued()


## The hairpin in the softened lock: a while of fiddling (DEX), then open.
func pick_lock() -> void:
	var time: float = GameManager.stats.effect("dex", "pick_time")
	if hero:
		hero.acting = true
		hero.bubble.say("SAY_PICKING", time)
	await get_tree().create_timer(time).timeout
	if hero:
		hero.acting = false
	await gate.use()
	EventBus.hero_line_requested.emit("SAY_GATE_PICKED")
	_sync()
	EventBus.autosave_requested.emit()


## Into the dark with a light: the end of the suite.
func to_be_continued() -> void:
	EventBus.set_modal_ui(true)
	if hero:
		await hero.walk_to(dark_passage.global_position + Vector2(0, -4), 0.8)
	ending = CanvasLayer.new()
	ending.layer = 40
	add_child(ending)
	var black: ColorRect = ColorRect.new()
	black.color = Color(0, 0, 0, 0)
	black.set_anchors_preset(Control.PRESET_FULL_RECT)
	ending.add_child(black)
	var label: Label = Hud.make_label("UI_TO_BE_CONTINUED")
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 16)
	label.modulate.a = 0.0
	ending.add_child(label)
	var tween: Tween = create_tween()
	tween.tween_property(black, "color:a", 1.0, END_FADE)
	tween.tween_property(label, "modulate:a", 1.0, END_FADE * 0.6)
	await tween.finished
	GameManager.set_flag("suite_done")
	EventBus.autosave_requested.emit()

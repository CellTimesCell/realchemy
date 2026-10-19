class_name Interactable
extends Node2D
## A prop the hero uses with ui_accept in its hotspot. One step bundles: the
## hero's pose, the prop's animation (closed -> ajar -> open textures, or a
## sliding part such as a drawer), an effect (dust on the first opening), a
## placeholder sound (AudioManager), a found item (ItemPop flies to the corner,
## EventBus.item_found) and a line in place of the prompt.
## Behaviour is data: data/interactables.json keyed by `interactable_id`;
## the scene only gives the nodes. Locked props rattle instead.

signal opened(prop: Interactable)
signal closed(prop: Interactable)

const TABLE_PATH: String = "res://data/interactables.json"
const STEP_TIME: float = 0.12
const POSE_LEAD: float = 0.2
const SLIDE_TIME: float = 0.25
const RATTLE_STEPS: int = 6
const RATTLE_STEP_TIME: float = 0.04

static var _table: Dictionary = {}

@export var interactable_id: String = ""
@export var hotspot: Hotspot
## Sprite that shows the states; also the one that rattles.
@export var sprite: Sprite2D
## Closed, ajar, open (anim "states").
@export var state_textures: Array[Texture2D] = []
## Part that slides out (anim "slide"), e.g. a drawer.
@export var moving_part: Node2D
@export var slide_offset: Vector2 = Vector2(0, 4)
## Shown only while open (things inside a wardrobe or a drawer).
@export var inside: Node2D
## Where dust and found items come from.
@export var fx_point: Node2D

var is_open: bool = false
var busy: bool = false
var config: Dictionary = {}
var _items_left: int = 0
var _fx_done: bool = false
var _first_prompt: String = ""


static func load_table() -> Dictionary:
	if _table.is_empty():
		var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(TABLE_PATH))
		_table = data if data is Dictionary else {}
	return _table


func _ready() -> void:
	config = load_table().get(interactable_id, {})
	if config.is_empty():
		push_warning("Interactable: no entry '%s' in %s" % [interactable_id, TABLE_PATH])
	_items_left = int(config.get("item", {}).get("count", 0))
	_first_prompt = hotspot.prompt_text
	if inside:
		inside.visible = false
	if sprite and not state_textures.is_empty():
		sprite.texture = state_textures[0]


func _unhandled_input(event: InputEvent) -> void:
	if busy or not hotspot.is_active() or not event.is_action_pressed("ui_accept"):
		return
	if not _wants_input():
		return
	get_viewport().set_input_as_handled()
	use()


## Subclasses (secretary) take over the input once the prop is open.
func _wants_input() -> bool:
	return not (is_open and not config.get("closable", false) and _items_left <= 0 and config.get("anim", "none") != "none")


func use() -> void:
	if config.get("locked", false):
		await rattle()
		return
	if is_open and config.get("closable", false):
		await close()
		return
	busy = true
	var hero: Hero = hotspot.hero
	if hero:
		hero.play_pose(config.get("pose", ""))
		await get_tree().create_timer(POSE_LEAD).timeout
	if not is_open:
		await _open_animation()
	# The item comes after the pose: its "notice" reaction would cut the pose.
	while hero and hero.acting:
		await get_tree().process_frame
	if _items_left > 0:
		_give_item()
	elif not config.get("empty_line_key", "").is_empty() and config.get("item", {}).size() > 0:
		hotspot.say(config["empty_line_key"])
	busy = false


func close() -> void:
	busy = true
	var sfx: Dictionary = config.get("sfx", {})
	match config.get("anim", "none"):
		"states":
			for i: int in range(state_textures.size() - 2, -1, -1):
				sprite.texture = state_textures[i]
				await get_tree().create_timer(STEP_TIME).timeout
		"slide":
			var tween: Tween = create_tween()
			tween.tween_property(moving_part, "position", moving_part.position - slide_offset, SLIDE_TIME)
			await tween.finished
			if sprite and not state_textures.is_empty():
				sprite.texture = state_textures[0]
	AudioManager.play_sfx(sfx.get("close", ""))
	if inside:
		inside.visible = false
	is_open = false
	_set_prompt(_first_prompt)
	busy = false
	closed.emit(self)


## Shakes the sprite by whole pixels and says why it does not open.
func rattle() -> void:
	busy = true
	AudioManager.play_sfx(config.get("sfx", {}).get("locked", "locked"))
	var target: Node2D = sprite if sprite else self
	var base: Vector2 = target.position
	for i: int in RATTLE_STEPS:
		target.position = base + Vector2(1 if i % 2 == 0 else -1, 0)
		await get_tree().create_timer(RATTLE_STEP_TIME).timeout
	target.position = base
	hotspot.say(config.get("locked_line_key", ""))
	busy = false


func _open_animation() -> void:
	var sfx: Dictionary = config.get("sfx", {})
	match config.get("anim", "none"):
		"none":
			return
		"states":
			AudioManager.play_sfx(sfx.get("start", ""))
			for i: int in range(1, state_textures.size()):
				sprite.texture = state_textures[i]
				await get_tree().create_timer(STEP_TIME).timeout
		"slide":
			AudioManager.play_sfx(sfx.get("start", ""))
			# Optional second texture: the body with an empty slot.
			if sprite and state_textures.size() >= 2:
				sprite.texture = state_textures[1]
			var tween: Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.tween_property(moving_part, "position", moving_part.position + slide_offset, SLIDE_TIME)
			await tween.finished
	AudioManager.play_sfx(sfx.get("end", ""))
	if config.get("fx", "") == "dust" and not (_fx_done and config.get("fx_once", true)):
		_fx_done = true
		_dust()
	if inside:
		inside.visible = true
	is_open = true
	if not config.get("prompt_after", "").is_empty():
		_set_prompt(config["prompt_after"])
	elif not config.get("closable", false):
		_set_prompt("")
	opened.emit(self)


func _give_item() -> void:
	var item: Dictionary = config["item"]
	_items_left -= 1
	var from: Vector2 = fx_point.global_position if fx_point else global_position + Vector2(0, -20)
	ItemPop.spawn(get_tree(), from, Color(item.get("color", "#ffffff")), item.get("letter", "?"))
	EventBus.item_found.emit(item.get("id", ""))
	if _items_left == 0 and config.has("prompt_after_empty"):
		hotspot.prompt_text = config["prompt_after_empty"]
	hotspot.say(config.get("line_key", ""))


func _set_prompt(key: String) -> void:
	hotspot.prompt_text = key
	if hotspot.prompt:
		hotspot.prompt.text = key


func _dust() -> void:
	var dust: CPUParticles2D = CPUParticles2D.new()
	dust.one_shot = true
	dust.amount = 18
	dust.lifetime = 0.9
	dust.explosiveness = 0.85
	dust.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	dust.emission_rect_extents = Vector2(18, 26)
	dust.direction = Vector2(0, -1)
	dust.spread = 70.0
	dust.gravity = Vector2(0, -6)
	dust.initial_velocity_min = 6.0
	dust.initial_velocity_max = 16.0
	dust.damping_min = 8.0
	dust.damping_max = 12.0
	dust.scale_amount_min = 1.0
	dust.scale_amount_max = 2.0
	var ramp: Gradient = Gradient.new()
	ramp.colors = PackedColorArray([Color(0.75, 0.7, 0.72, 0.8), Color(0.75, 0.7, 0.72, 0.0)])
	dust.color_ramp = ramp
	dust.position = fx_point.position if fx_point else Vector2(0, -60)
	add_child(dust)
	dust.emitting = true
	dust.finished.connect(dust.queue_free)

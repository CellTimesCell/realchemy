class_name Emote
extends AnimatedSprite2D
## Manpu icon on a character's head ("...", "!", anger vein...). show_emote()
## queues icons: each one pops in (rises a few whole pixels), loops its
## animation for the given time, then fades out. Unknown icon names are ignored.
## Where an icon sits is data (data/emotes.json): a head marker (Head_Top,
## Forehead, Temple_L, Temple_R under `head`), an offset toward the face and a
## scale; the side mirrors when the character looks the other way (body.flip_h).
## Icons with several places (sparkle) get extra sprites; gloom adds a shade.
## The icon is drawn on the overlay CanvasLayer (`overlay`, or the scene's
## "above_night" group layer) above the night tint, so white stays white.

signal emote_finished(emote_name: String)

const TABLE_PATH: String = "res://data/emotes.json"
const RISE_PX: int = 3
const RISE_STEP_TIME: float = 0.03
const FADE_TIME: float = 0.15
const SHADE_SIZE: Vector2i = Vector2i(20, 10)
const SHADE_ALPHA: float = 0.45

@export var default_time: float = 1.4
## Layer drawn above the night tint (follow_viewport_enabled = true).
@export var overlay: CanvasLayer
## Key in data/emotes.json "characters".
@export var character: String = "hero"
## Holds the Head_Top, Forehead, Temple_L, Temple_R markers.
@export var head: Node2D
## Body sprite: its flip_h and animation tell where the face is.
@export var body: AnimatedSprite2D

static var _table: Dictionary = {}

var _queue: Array[Array] = []
var _busy: bool = false
var _anchor: Node2D
var _rise: int = 0
var _places: Array = []
var _flip: bool = false
var _extras: Array[AnimatedSprite2D] = []
var _shade: Sprite2D


static func load_table() -> Dictionary:
	if _table.is_empty():
		var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(TABLE_PATH))
		_table = data if data is Dictionary else {}
	return _table


func _ready() -> void:
	visible = false
	_anchor = get_parent() as Node2D
	_shade = _make_shade()
	add_child(_shade)
	if not overlay:
		overlay = get_tree().get_first_node_in_group(&"above_night") as CanvasLayer
	if overlay:
		reparent.call_deferred(overlay, false)


func _process(_delta: float) -> void:
	if overlay and not is_instance_valid(_anchor):
		queue_free()
		return
	if _places.is_empty():
		return
	var origin: Vector2 = place_position(_places[0])
	global_position = origin + Vector2(0, _rise)
	for i: int in mini(_extras.size(), _places.size() - 1):
		_extras[i].position = (place_position(_places[i + 1]) - origin) / scale
	if _shade.visible:
		_shade.position = (_marker_position("forehead") - origin) / scale


func show_emote(emote_name: String, time: float = -1.0) -> void:
	if sprite_frames == null or not sprite_frames.has_animation(emote_name):
		return
	_queue.append([emote_name, default_time if time < 0.0 else time])
	if not _busy:
		_run_queue()


func clear_queue() -> void:
	_queue.clear()


## True when the character's face points to the left of the screen.
func looks_left() -> bool:
	var face_right: bool = _character_config().get("face_side", "right") == "right"
	var flipped: bool = body != null and body.flip_h
	return face_right == flipped


## Global position of one placement (anchor + mirrored offset).
func place_position(place: Dictionary) -> Vector2:
	var side: float = -1.0 if looks_left() else 1.0
	var offset: Array = place.get("offset", [0, 0])
	return _marker_position(place.get("anchor", "head_top")) + Vector2(offset[0] * side, offset[1])


func _marker_position(anchor_name: String) -> Vector2:
	var base: Vector2 = Vector2.ZERO
	var marker: Node2D = _marker(anchor_name)
	if marker:
		# Markers are placed on the unflipped sprite; mirror them with it.
		var local: Vector2 = marker.position
		if body and body.flip_h:
			local.x = -local.x
		base = head.global_position + local
	elif is_instance_valid(_anchor):
		base = _anchor.global_position
	if body:
		var shifts: Dictionary = _character_config().get("anim_head_offset", {})
		var shift: Array = shifts.get(String(body.animation), [0, 0])
		base += Vector2(shift[0], shift[1])
	return base


## Temple_L / Temple_R are named for the unflipped sprite.
func _marker(anchor_name: String) -> Node2D:
	if not head:
		return null
	var face_right: bool = _character_config().get("face_side", "right") == "right"
	match anchor_name:
		"head_top":
			return head.get_node_or_null("Head_Top") as Node2D
		"forehead":
			return head.get_node_or_null("Forehead") as Node2D
		"temple_face":
			return head.get_node_or_null("Temple_R" if face_right else "Temple_L") as Node2D
		"temple_back":
			return head.get_node_or_null("Temple_L" if face_right else "Temple_R") as Node2D
	return null


func _character_config() -> Dictionary:
	return load_table().get("characters", {}).get(character, {})


func _icon_config(emote_name: String) -> Dictionary:
	var config: Dictionary = load_table().get("icons", {}).get(emote_name, {})
	if not config.has("places"):
		config = {"places": [{"anchor": "head_top", "offset": [0, -12]}]}
	return config


func _run_queue() -> void:
	_busy = true
	while not _queue.is_empty():
		var item: Array = _queue.pop_front()
		await _show_one(item[0], item[1])
	_busy = false


func _show_one(emote_name: String, time: float) -> void:
	var config: Dictionary = _icon_config(emote_name)
	_places = config["places"]
	_flip = config.get("flip", false)
	var base_scale: float = _places[0].get("scale", 1.0)
	scale = Vector2(base_scale, base_scale)
	flip_h = _flip and looks_left()
	play(emote_name)
	_setup_extras(emote_name, base_scale)
	_shade.visible = config.get("shade", false)
	modulate.a = 1.0
	visible = true
	for step: int in RISE_PX + 1:
		_rise = RISE_PX - step
		await get_tree().create_timer(RISE_STEP_TIME).timeout
	await get_tree().create_timer(time).timeout
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, FADE_TIME)
	await tween.finished
	visible = false
	stop()
	for extra: AnimatedSprite2D in _extras:
		extra.stop()
	emote_finished.emit(emote_name)


func _setup_extras(emote_name: String, base_scale: float) -> void:
	while _extras.size() < _places.size() - 1:
		var extra: AnimatedSprite2D = AnimatedSprite2D.new()
		extra.sprite_frames = sprite_frames
		add_child(extra)
		_extras.append(extra)
	for i: int in _extras.size():
		var extra: AnimatedSprite2D = _extras[i]
		extra.visible = i < _places.size() - 1
		if not extra.visible:
			continue
		var place: Dictionary = _places[i + 1]
		var place_scale: float = place.get("scale", 1.0) / base_scale
		extra.scale = Vector2(place_scale, place_scale)
		extra.flip_h = flip_h
		extra.play(emote_name)
		var frames: int = sprite_frames.get_frame_count(emote_name)
		extra.frame = int(place.get("frame_shift", 0)) % maxi(frames, 1)


func _make_shade() -> Sprite2D:
	# Stepped alpha (3 bands), no smooth fade in pixel art.
	var gradient: Gradient = Gradient.new()
	var tint: Color = Color(0.05, 0.03, 0.12)
	gradient.offsets = PackedFloat32Array([0.0, 0.34, 0.67])
	gradient.colors = PackedColorArray([Color(tint, SHADE_ALPHA), Color(tint, SHADE_ALPHA * 0.6), Color(tint, SHADE_ALPHA * 0.25)])
	gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
	var texture: GradientTexture2D = GradientTexture2D.new()
	texture.gradient = gradient
	texture.width = SHADE_SIZE.x
	texture.height = SHADE_SIZE.y
	texture.fill_to = Vector2(0, 1)
	var shade: Sprite2D = Sprite2D.new()
	shade.texture = texture
	shade.show_behind_parent = true
	shade.offset = Vector2(0, SHADE_SIZE.y * 0.5)
	shade.visible = false
	return shade

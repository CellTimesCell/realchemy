class_name CountPortrait
extends Node2D
## The Count's portrait lives a little: it blinks every few seconds (an
## eyelid overlay over the following eyes) and now and then yawns (mouth
## overlay frames over the painting; the eyes hide meanwhile). Looked at
## right after a yawn, the hero doubts his eyes (yawn_say_key).

const BLINK_HALF: float = 0.05
const BLINK_SHUT: float = 0.1
const YAWN_STEP: float = 0.16
const YAWN_HOLD: float = 1.2
## How long after a yawn inspecting the painting gives the yawn line.
const YAWN_MEMORY: float = 20.0

@export var eyes: Sprite2D
## Eyelids: 2 frames (half shut, shut), same canvas as the painting.
@export var lids: Sprite2D
## Yawn mouth: 3 frames (opening, wide, widest), same canvas as the painting.
@export var yawn_overlay: Sprite2D
@export var hotspot: Hotspot
@export var yawn_say_key: String = "SAY_PORTRAIT_YAWN"
@export var blink_min: float = 4.0
@export var blink_max: float = 8.0
@export var yawn_min: float = 40.0
@export var yawn_max: float = 60.0

var yawning: bool = false
var _blink_left: float = 0.0
var _yawn_left: float = 0.0
var _normal_say_key: String = ""


func _ready() -> void:
	lids.visible = false
	yawn_overlay.visible = false
	if hotspot:
		_normal_say_key = hotspot.say_key
	_blink_left = randf_range(blink_min, blink_max)
	_yawn_left = randf_range(yawn_min, yawn_max)


func _process(delta: float) -> void:
	# The lids ride with the eyes when those slide toward the hero.
	lids.offset = eyes.offset
	if yawning:
		return
	_blink_left -= delta
	_yawn_left -= delta
	if _yawn_left <= 0.0:
		yawn()
	elif _blink_left <= 0.0:
		blink()


func blink() -> void:
	_blink_left = randf_range(blink_min, blink_max)
	lids.visible = true
	for frame: int in [0, 1, 0]:
		lids.frame = frame
		await get_tree().create_timer(BLINK_SHUT if frame == 1 else BLINK_HALF).timeout
	lids.visible = false


func yawn() -> void:
	if yawning:
		return
	yawning = true
	_yawn_left = randf_range(yawn_min, yawn_max)
	lids.visible = false
	eyes.visible = false
	yawn_overlay.visible = true
	for frame: int in [0, 1, 2, 2, 1, 0]:
		yawn_overlay.frame = frame
		await get_tree().create_timer(YAWN_HOLD if frame == 2 else YAWN_STEP).timeout
	yawn_overlay.visible = false
	eyes.visible = true
	yawning = false
	_remember_yawn()


func _remember_yawn() -> void:
	if not hotspot or yawn_say_key.is_empty():
		return
	hotspot.say_key = yawn_say_key
	await get_tree().create_timer(YAWN_MEMORY).timeout
	hotspot.say_key = _normal_say_key

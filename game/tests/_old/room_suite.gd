extends Node2D
## Temporary art check: a suite of 640x360 rooms side by side. The hero walks
## with the arrow keys; the camera stays on one room and slides to the next
## when the hero crosses into it.

const ROOM_WIDTH: float = 640.0
const ROOM_HEIGHT: float = 360.0
const CAMERA_SLIDE_TIME: float = 0.4
const HERO_SPEED: float = 120.0

@export var hero: Node2D
@export var camera: Camera2D
@export var hero_anim: AnimatedSprite2D
@export var room_count: int = 3
@export var floor_top: float = 250.0
@export var floor_bottom: float = 340.0
## Walking up into this rect (world coords) moves the hero through the arch.
@export var arch_rect: Rect2 = Rect2(430, 245, 54, 20)
@export var arch_target: Vector2 = Vector2(700, 290)

var _room_index: int = -1
var _tween: Tween
var _facing: String = "south"
var _emoting: bool = false


func _ready() -> void:
	_update_room(true)
	if hero_anim:
		hero_anim.animation_finished.connect(_on_hero_anim_finished)


func _unhandled_input(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if key and key.pressed and not key.echo and key.physical_keycode == KEY_E:
		_play_emote()


func _process(delta: float) -> void:
	if _emoting:
		return
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction.y < 0.0 and arch_rect.has_point(hero.position):
		hero.position = arch_target
	var target: Vector2 = hero.position + direction * HERO_SPEED * delta
	target.x = clampf(target.x, 16.0, ROOM_WIDTH * room_count - 16.0)
	target.y = clampf(target.y, floor_top, floor_bottom)
	hero.position = target
	_update_animation(direction)
	_update_room(false)


func _update_animation(direction: Vector2) -> void:
	if not hero_anim:
		return
	if direction != Vector2.ZERO:
		if absf(direction.x) > absf(direction.y):
			_facing = "east" if direction.x > 0.0 else "west"
		else:
			_facing = "south" if direction.y > 0.0 else "north"
	# West reuses the east frames mirrored.
	hero_anim.flip_h = _facing == "west"
	var side: String = "east" if _facing == "west" else _facing
	if direction != Vector2.ZERO:
		hero_anim.play("walk_" + side)
	elif _facing == "south":
		hero_anim.play("idle_south")
	else:
		# Only a south idle exists: stand on the first walk frame.
		hero_anim.animation = "walk_" + side
		hero_anim.frame = 0
		hero_anim.stop()


func _play_emote() -> void:
	if not hero_anim or not hero_anim.sprite_frames.has_animation("emote_scratch_head"):
		return
	_emoting = true
	hero_anim.flip_h = false
	hero_anim.play("emote_scratch_head")


func _on_hero_anim_finished() -> void:
	if hero_anim.animation == "emote_scratch_head":
		_emoting = false
		_facing = "south"


func _update_room(instant: bool) -> void:
	var index: int = clampi(int(hero.position.x / ROOM_WIDTH), 0, room_count - 1)
	if index == _room_index:
		return
	_room_index = index
	var center: Vector2 = Vector2(ROOM_WIDTH * (index + 0.5), ROOM_HEIGHT * 0.5)
	if _tween:
		_tween.kill()
	if instant:
		camera.position = center
		return
	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(camera, "position", center, CAMERA_SLIDE_TIME)

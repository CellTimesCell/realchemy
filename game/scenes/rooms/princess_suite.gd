extends Node2D
## Princess suite: three 640x360 rooms in a row (bedroom | boudoir | dressing
## room). The camera stays on one room and slides to the next when the hero
## crosses into it; walking up into the bedroom arch leads to the boudoir.

const ROOM_WIDTH: float = 640.0
const ROOM_HEIGHT: float = 360.0
const CAMERA_SLIDE_TIME: float = 0.4

@export var hero: Hero
@export var camera: Camera2D
@export var room_count: int = 3
## Walking up into this rect (world coords) moves the hero through the arch.
@export var arch_rect: Rect2 = Rect2(430, 245, 54, 22)
@export var arch_target: Vector2 = Vector2(700, 290)

var _room_index: int = -1
var _tween: Tween


func _ready() -> void:
	_update_room(true)


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("ui_up") and arch_rect.has_point(hero.position):
		hero.position = arch_target
	_update_room(false)


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

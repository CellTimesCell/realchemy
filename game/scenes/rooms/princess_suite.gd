extends Node2D
## Princess suite: three 640x360 rooms in a row (bedroom | boudoir | dressing
## room). The camera stays on one room and slides to the next when the hero
## crosses into it. The bedroom leads to the boudoir only through its right
## edge (the central arch is the garderobe door now).
## Rooms behind doors sit in further rows below (y >= 360): a door fades the
## screen, so the camera jumps there without sliding.

const ROOM_WIDTH: float = 640.0
const ROOM_HEIGHT: float = 360.0
const CAMERA_SLIDE_TIME: float = 0.4

@export var hero: Hero
@export var camera: Camera2D
@export var room_count: int = 3

var _room_index: Vector2i = Vector2i(-1, -1)
var _tween: Tween


func _ready() -> void:
	_update_room(true)


func _physics_process(_delta: float) -> void:
	_update_room(false)


func _update_room(instant: bool) -> void:
	var index: Vector2i = Vector2i(
		clampi(int(hero.position.x / ROOM_WIDTH), 0, room_count - 1),
		maxi(int(hero.position.y / ROOM_HEIGHT), 0))
	if index == _room_index:
		return
	var row_changed: bool = index.y != _room_index.y
	_room_index = index
	var center: Vector2 = Vector2(ROOM_WIDTH * (index.x + 0.5), ROOM_HEIGHT * (index.y + 0.5))
	if _tween:
		_tween.kill()
	if instant or row_changed:
		camera.position = center
		return
	_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(camera, "position", center, CAMERA_SLIDE_TIME)

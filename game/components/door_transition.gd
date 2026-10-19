class_name DoorTransition
extends Node2D
## A door to another room. ui_accept in the hotspot: the door opens (closed ->
## ajar -> open), the hero steps into the doorway, the screen fades out, the
## hero appears at `exit_point` on the other side, the screen fades in. The
## door closes behind. A locked door rattles and says `locked_line_key`;
## with `locked_first_time` only the first try rattles, then it opens.
## With `first_person_view` set, the door opens onto that screen instead of
## another room; when the view closes the hero steps back out.
## Arches inside a suite do not use this: the camera just slides.

const STEP_TIME: float = 0.12
const STEP_IN_TIME: float = 0.35
const RATTLE_STEPS: int = 6
const RATTLE_STEP_TIME: float = 0.04

@export var hotspot: Hotspot
## Overlay drawn over the baked door; textures: closed (may be null), ajar, open.
@export var door_sprite: Sprite2D
@export var state_textures: Array[Texture2D] = []
@export var transition: ScreenTransition
## Where the hero appears in the other room.
@export var exit_point: Node2D
## Point in this doorway the hero walks to before the fade (local).
@export var step_in: Vector2 = Vector2(0, -6)
@export var locked: bool = false
## Rattle on the first try only ("Locked. From the inside?"), then open.
@export var locked_first_time: bool = false
@export var locked_line_key: String = ""
@export var first_person_view: FirstPersonView

var busy: bool = false
var _tried: bool = false


func _ready() -> void:
	_set_state(0)


func _unhandled_input(event: InputEvent) -> void:
	if busy or not hotspot.is_active() or not event.is_action_pressed("ui_accept"):
		return
	get_viewport().set_input_as_handled()
	if locked or (locked_first_time and not _tried):
		_tried = true
		_rattle()
	elif first_person_view:
		look_inside(hotspot.hero)
	else:
		go_through(hotspot.hero)


## Opens the door onto a first-person screen; the hero steps back out after.
func look_inside(hero: Hero) -> void:
	busy = true
	EventBus.set_modal_ui(true)
	await _open_door()
	var start: Vector2 = hero.global_position if hero else Vector2.ZERO
	if hero:
		await hero.walk_to(global_position + step_in, STEP_IN_TIME)
	await first_person_view.open()
	await first_person_view.closed_view
	_set_state(0)
	AudioManager.play_sfx("close")
	if hero:
		hero.global_position = start
		hero.face("south")
	EventBus.set_modal_ui(false)
	busy = false


func _open_door() -> void:
	AudioManager.play_sfx("creak")
	for i: int in range(1, state_textures.size()):
		_set_state(i)
		await get_tree().create_timer(STEP_TIME).timeout
	AudioManager.play_sfx("open")


func go_through(hero: Hero) -> void:
	busy = true
	EventBus.set_modal_ui(true)
	await _open_door()
	if hero:
		await hero.walk_to(global_position + step_in, STEP_IN_TIME)
	await transition.fade_out()
	if hero and exit_point:
		hero.global_position = exit_point.global_position
		hero.face("south")
	_set_state(0)
	AudioManager.play_sfx("close")
	await transition.fade_in()
	EventBus.set_modal_ui(false)
	busy = false


func _rattle() -> void:
	busy = true
	AudioManager.play_sfx("locked")
	var base: Vector2 = door_sprite.position if door_sprite else position
	for i: int in RATTLE_STEPS:
		var shift: Vector2 = Vector2(1 if i % 2 == 0 else -1, 0)
		if door_sprite:
			door_sprite.position = base + shift
		await get_tree().create_timer(RATTLE_STEP_TIME).timeout
	if door_sprite:
		door_sprite.position = base
	hotspot.say(locked_line_key)
	busy = false


func _set_state(index: int) -> void:
	if not door_sprite or state_textures.is_empty():
		return
	door_sprite.texture = state_textures[index]
	door_sprite.visible = state_textures[index] != null

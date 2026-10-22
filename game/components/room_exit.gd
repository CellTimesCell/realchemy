class_name RoomExit
extends Node2D
## A doorway to the next room: ui_accept in its hotspot -> the hero steps in,
## fade out, the next room (target_scene) loads. Until that room exists the
## exit is a stub: fade out, the hero is back at return_point, fade in and
## says why (line_key).

const STEP_TIME: float = 0.35

@export var hotspot: Hotspot
@export var transition: ScreenTransition
## The next room; empty = not built yet (stub).
@export_file("*.tscn") var target_scene: String = ""
## Where the hero walks to before the fade (the doorway), relative to this node.
@export var step_in: Vector2 = Vector2(8, -6)
## Where the hero stands again after a stub fade, relative to this node.
@export var return_point: Vector2 = Vector2(-28, 12)
@export var line_key: String = "SAY_DOOR_NOT_YET"

var busy: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if busy or not hotspot.is_active() or not event.is_action_pressed("ui_accept"):
		return
	get_viewport().set_input_as_handled()
	go(hotspot.hero)


func go(hero: Hero) -> void:
	busy = true
	EventBus.set_modal_ui(true)
	if hero:
		await hero.walk_to(global_position + step_in, STEP_TIME)
	await transition.fade_out()
	if not target_scene.is_empty() and ResourceLoader.exists(target_scene):
		EventBus.autosave_requested.emit()
		EventBus.set_modal_ui(false)
		get_tree().change_scene_to_file(target_scene)
		return
	if hero:
		hero.global_position = global_position + return_point
		hero.face("south")
	await transition.fade_in()
	EventBus.set_modal_ui(false)
	if hero and hero.bubble:
		hero.bubble.say(line_key)
	busy = false

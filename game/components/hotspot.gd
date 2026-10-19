class_name Hotspot
extends Area2D
## Interactive spot: shows a prompt while the hero stands inside the area.
## Texts are localization keys. If say_key is set, ui_accept shows that line
## in place of the prompt for a few seconds (placeholder for real dialogue).
## Prompts hide and input is ignored while a modal UI is open (EventBus).
## The prompt label moves onto the "above_night" CanvasLayer (if the scene has
## one), so the night tint does not grey it out, and follows the hotspot.

signal hero_entered(hotspot: Hotspot)
signal hero_exited(hotspot: Hotspot)

const SAY_TIME: float = 3.0
const OVERLAY_GROUP: StringName = &"above_night"

@export var prompt_text: String = "UI_INSPECT"
@export var say_key: String = ""
@export var prompt: Label

## The hero standing in the area (null when nobody is).
var hero: Hero
var _hero_inside: bool = false
var _prompt_offset: Vector2 = Vector2.ZERO
var _prompt_moved: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	EventBus.modal_ui_changed.connect(_on_modal_ui_changed)
	set_process(false)
	if prompt:
		prompt.text = prompt_text
		prompt.visible = false
		var overlay: CanvasLayer = get_tree().get_first_node_in_group(OVERLAY_GROUP) as CanvasLayer
		if overlay:
			_prompt_offset = prompt.position
			_prompt_moved = true
			prompt.reparent.call_deferred(overlay, false)
			set_process(true)


func _process(_delta: float) -> void:
	prompt.position = global_position + _prompt_offset


func _exit_tree() -> void:
	if _prompt_moved and is_instance_valid(prompt):
		prompt.queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if say_key.is_empty() or not _hero_inside or not is_visible_in_tree() or EventBus.modal_ui_active:
		return
	if event.is_action_pressed("ui_accept") and prompt:
		get_viewport().set_input_as_handled()
		say(say_key)


## True while the hero stands in the area and nothing modal is open.
func is_active() -> bool:
	return _hero_inside and is_visible_in_tree() and not EventBus.modal_ui_active and not (hero and hero.acting)


## Shows a line in place of the prompt for a few seconds.
func say(key: String) -> void:
	if not prompt:
		return
	prompt.text = key
	await get_tree().create_timer(SAY_TIME).timeout
	if prompt.text == key:
		prompt.text = prompt_text


func _on_body_entered(body: Node2D) -> void:
	if body is Hero and is_visible_in_tree():
		hero = body as Hero
		_hero_inside = true
		if prompt:
			prompt.visible = not EventBus.modal_ui_active
		hero_entered.emit(self)


func _on_body_exited(body: Node2D) -> void:
	if body is Hero:
		hero = null
		_hero_inside = false
		if prompt:
			prompt.visible = false
		hero_exited.emit(self)


func _on_modal_ui_changed(active: bool) -> void:
	if prompt:
		prompt.visible = _hero_inside and not active

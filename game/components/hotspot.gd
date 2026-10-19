class_name Hotspot
extends Area2D
## Interactive spot: shows a prompt while the hero stands inside the area.
## Texts are localization keys. If say_key is set, ui_accept shows that line
## in place of the prompt for a few seconds (placeholder for real dialogue).

signal hero_entered(hotspot: Hotspot)
signal hero_exited(hotspot: Hotspot)

const SAY_TIME: float = 3.0

@export var prompt_text: String = "UI_INSPECT"
@export var say_key: String = ""
@export var prompt: Label

var _hero_inside: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	if prompt:
		prompt.text = prompt_text
		prompt.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if say_key.is_empty() or not _hero_inside or not is_visible_in_tree():
		return
	if event.is_action_pressed("ui_accept") and prompt:
		prompt.text = say_key
		get_viewport().set_input_as_handled()
		await get_tree().create_timer(SAY_TIME).timeout
		prompt.text = prompt_text


func _on_body_entered(body: Node2D) -> void:
	if body is Hero and is_visible_in_tree():
		_hero_inside = true
		if prompt:
			prompt.visible = true
		hero_entered.emit(self)


func _on_body_exited(body: Node2D) -> void:
	if body is Hero:
		_hero_inside = false
		if prompt:
			prompt.visible = false
		hero_exited.emit(self)

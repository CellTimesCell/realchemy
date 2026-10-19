class_name LetterScreen
extends CanvasLayer
## Full-screen reader for letters and notes: dimmed backdrop, parchment, text
## from a localization key. Closes on click or Esc.

signal closed

@export var text_label: Label


func show_letter(text_key: String) -> void:
	text_label.text = text_key
	visible = true


func _ready() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	var click: InputEventMouseButton = event as InputEventMouseButton
	if event.is_action_pressed("ui_cancel") or (click and click.pressed):
		visible = false
		get_viewport().set_input_as_handled()
		closed.emit()

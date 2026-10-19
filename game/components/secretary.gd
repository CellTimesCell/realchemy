class_name Secretary
extends OpenableProp
## Writing desk: the first Enter opens the lid, the next one reads the letter.

@export var letter_key: String = "LETTER_PREDECESSOR"
@export var letter_screen: LetterScreen


func _unhandled_input(event: InputEvent) -> void:
	if is_open and _hero_near and event.is_action_pressed("ui_accept") and not EventBus.modal_ui_active:
		letter_screen.show_letter(letter_key)
		get_viewport().set_input_as_handled()
		return
	super._unhandled_input(event)


func _set_open(value: bool) -> void:
	super._set_open(value)
	if value and hotspot.prompt:
		hotspot.prompt.text = "UI_READ_LETTER"

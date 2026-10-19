class_name Secretary
extends Interactable
## Writing desk: the first Enter opens the lid (closed -> ajar -> open), the
## next one reads the letter.

@export var letter_key: String = "LETTER_PREDECESSOR"
@export var letter_screen: LetterScreen


func _unhandled_input(event: InputEvent) -> void:
	if is_open and not busy and hotspot.is_active() and event.is_action_pressed("ui_accept"):
		letter_screen.show_letter(letter_key)
		get_viewport().set_input_as_handled()
		return
	super._unhandled_input(event)
